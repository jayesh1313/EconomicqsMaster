export const validateEmail = (email) => {
  const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return regex.test(email)
}

export const validatePassword = (password) => {
  return password && password.length >= 8
}

export const validateForm = (formData, rules) => {
  const errors = {}

  Object.keys(rules).forEach((field) => {
    const rule = rules[field]
    const value = formData[field]

    if (rule.required && !value) {
      errors[field] = `${field} is required`
    }

    if (rule.minLength && value && value.length < rule.minLength) {
      errors[field] = `${field} must be at least ${rule.minLength} characters`
    }

    if (rule.maxLength && value && value.length > rule.maxLength) {
      errors[field] = `${field} must not exceed ${rule.maxLength} characters`
    }

    if (rule.email && value && !validateEmail(value)) {
      errors[field] = 'Invalid email address'
    }
  })

  return errors
}
