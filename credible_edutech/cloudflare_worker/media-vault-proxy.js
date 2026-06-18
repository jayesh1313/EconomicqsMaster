/**
 * CredibleEdutech Media Vault Proxy
 * Cloudflare Workers Script
 * 
 * Functionality:
 * - JWT validation via Supabase
 * - Google Drive API integration
 * - Byte-range request support for video seeking
 * - CORS enforcement
 * - Short-lived IAM token generation
 */

// Configuration
const CONFIG = {
  SUPABASE_URL: 'https://your-project.supabase.co',
  SUPABASE_ANON_KEY: 'your-anon-key',
  GOOGLE_SERVICE_ACCOUNT_EMAIL: 'your-service-account@project.iam.gserviceaccount.com',
  GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY: 'your-private-key',
  GOOGLE_PROJECT_ID: 'your-project-id',
  ALLOWED_ORIGINS: ['app://economicqsmaster.com', 'https://economicqsmaster.com'],
};

/**
 * Validate JWT token with Supabase
 */
async function validateJWT(token) {
  try {
    const response = await fetch(`${CONFIG.SUPABASE_URL}/auth/v1/user`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`,
        'apikey': CONFIG.SUPABASE_ANON_KEY,
      },
    });

    if (!response.ok) {
      return { valid: false, error: 'Invalid token' };
    }

    const user = await response.json();
    return { valid: true, user };
  } catch (error) {
    console.error('JWT validation error:', error);
    return { valid: false, error: 'Token validation failed' };
  }
}

/**
 * Generate Google IAM access token for service account
 */
async function getGoogleAccessToken() {
  try {
    // Create JWT for Google Service Account
    const header = {
      alg: 'RS256',
      typ: 'JWT',
    };

    const now = Math.floor(Date.now() / 1000);
    const payload = {
      iss: CONFIG.GOOGLE_SERVICE_ACCOUNT_EMAIL,
      sub: CONFIG.GOOGLE_SERVICE_ACCOUNT_EMAIL,
      scope: 'https://www.googleapis.com/auth/drive.readonly',
      aud: 'https://oauth2.googleapis.com/token',
      exp: now + 3600,
      iat: now,
    };

    // Encode JWT (Note: In production, use a JWT library)
    const encodedHeader = btoa(JSON.stringify(header));
    const encodedPayload = btoa(JSON.stringify(payload));
    const tokenToSign = `${encodedHeader}.${encodedPayload}`;

    // Sign JWT (this is simplified; use crypto library in production)
    const signature = await generateSignature(tokenToSign, CONFIG.GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY);
    const jwt = `${tokenToSign}.${signature}`;

    // Exchange JWT for access token
    const response = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: new URLSearchParams({
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: jwt,
      }),
    });

    if (!response.ok) {
      throw new Error('Failed to get access token');
    }

    const data = await response.json();
    return data.access_token;
  } catch (error) {
    console.error('Google token generation error:', error);
    throw error;
  }
}

/**
 * Proxy request to Google Drive API
 */
async function proxyGoogleDriveRequest(fileId, accessToken, rangeHeader) {
  try {
    const driveUrl = `https://www.googleapis.com/drive/v3/files/${fileId}?alt=media`;

    const headers = {
      'Authorization': `Bearer ${accessToken}`,
    };

    if (rangeHeader) {
      headers['Range'] = rangeHeader;
    }

    const response = await fetch(driveUrl, {
      method: 'GET',
      headers,
    });

    if (!response.ok) {
      throw new Error(`Google Drive request failed: ${response.status}`);
    }

    return response;
  } catch (error) {
    console.error('Google Drive proxy error:', error);
    throw error;
  }
}

/**
 * Generate RSA signature (simplified)
 * In production, use crypto libraries
 */
async function generateSignature(data, privateKey) {
  // This is a placeholder. In production use proper crypto libraries
  // For Cloudflare Workers, use the SubtleCrypto API
  try {
    const key = await crypto.subtle.importKey(
      'pkcs8',
      Buffer.from(privateKey),
      {
        name: 'RSASSA-PKCS1-v1_5',
        hash: 'SHA-256',
      },
      false,
      ['sign']
    );

    const signature = await crypto.subtle.sign(
      'RSASSA-PKCS1-v1_5',
      key,
      Buffer.from(data)
    );

    return btoa(String.fromCharCode.apply(null, new Uint8Array(signature)));
  } catch (error) {
    console.error('Signature generation error:', error);
    throw error;
  }
}

/**
 * Add CORS headers to response
 */
function addCORSHeaders(response, origin) {
  const newResponse = new Response(response.body, response);

  if (CONFIG.ALLOWED_ORIGINS.includes(origin)) {
    newResponse.headers.set('Access-Control-Allow-Origin', origin);
    newResponse.headers.set('Access-Control-Allow-Methods', 'GET, HEAD, OPTIONS');
    newResponse.headers.set('Access-Control-Allow-Headers', 'Authorization, Range, Content-Type');
    newResponse.headers.set('Access-Control-Max-Age', '86400');
  }

  // Support byte-range requests
  newResponse.headers.set('Accept-Ranges', 'bytes');

  return newResponse;
}

/**
 * Main worker handler
 */
async function handleRequest(request) {
  const origin = request.headers.get('Origin');

  // Handle preflight
  if (request.method === 'OPTIONS') {
    return addCORSHeaders(new Response(null, { status: 204 }), origin);
  }

  try {
    const url = new URL(request.url);
    const fileId = url.searchParams.get('fileId');
    const jwt = url.searchParams.get('jwt');

    if (!fileId || !jwt) {
      return addCORSHeaders(
        new Response(JSON.stringify({ error: 'Missing fileId or jwt' }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' },
        }),
        origin
      );
    }

    // Validate JWT
    const validation = await validateJWT(jwt);
    if (!validation.valid) {
      return addCORSHeaders(
        new Response(JSON.stringify({ error: 'Invalid JWT' }), {
          status: 401,
          headers: { 'Content-Type': 'application/json' },
        }),
        origin
      );
    }

    // Get Google access token
    const accessToken = await getGoogleAccessToken();

    // Get Range header if present
    const rangeHeader = request.headers.get('Range');

    // Proxy to Google Drive
    const response = await proxyGoogleDriveRequest(fileId, accessToken, rangeHeader);

    // Handle 206 Partial Content (byte-range requests)
    if (response.status === 206) {
      return addCORSHeaders(response, origin);
    }

    // Handle 200 OK
    if (response.ok) {
      return addCORSHeaders(response, origin);
    }

    throw new Error(`Unexpected status: ${response.status}`);
  } catch (error) {
    console.error('Request handler error:', error);
    return addCORSHeaders(
      new Response(JSON.stringify({ error: 'Internal server error' }), {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }),
      origin
    );
  }
}

/**
 * Cloudflare Worker event listener
 */
addEventListener('fetch', (event) => {
  event.respondWith(handleRequest(event.request));
});

// For Cloudflare Workers with module syntax
export default {
  async fetch(request) {
    return handleRequest(request);
  },
};
