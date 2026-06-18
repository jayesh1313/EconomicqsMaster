import { Settings as SettingsIcon, Save, Bell, Lock, Palette } from 'lucide-react'
import Card from '../components/Card'
import { useState } from 'react'

const Settings = () => {
  const [settings, setSettings] = useState({
    appName: 'Web Project',
    theme: 'light',
    notifications: true,
    emailNotifications: true,
    twoFactor: false,
  })

  const handleSettingChange = (key, value) => {
    setSettings({ ...settings, [key]: value })
  }

  const handleSave = () => {
    alert('Settings saved successfully!')
  }

  return (
    <div className="p-8 bg-gray-100 min-h-screen">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-4xl font-bold text-gray-800 mb-2">Settings</h1>
        <p className="text-gray-600">Configure your application settings</p>
      </div>

      {/* General Settings */}
      <Card title="General Settings" icon={SettingsIcon} className="mb-6">
        <div className="space-y-6">
          <div>
            <label className="block text-gray-700 font-medium mb-2">Application Name</label>
            <input
              type="text"
              value={settings.appName}
              onChange={(e) => handleSettingChange('appName', e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
          <div>
            <label className="block text-gray-700 font-medium mb-2">Email Address</label>
            <input
              type="email"
              placeholder="admin@example.com"
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>
      </Card>

      {/* Appearance */}
      <Card title="Appearance" icon={Palette} className="mb-6">
        <div className="space-y-6">
          <div>
            <label className="block text-gray-700 font-medium mb-3">Theme</label>
            <div className="flex gap-4">
              <label className="flex items-center">
                <input
                  type="radio"
                  name="theme"
                  value="light"
                  checked={settings.theme === 'light'}
                  onChange={(e) => handleSettingChange('theme', e.target.value)}
                  className="w-4 h-4"
                />
                <span className="ml-2 text-gray-700">Light</span>
              </label>
              <label className="flex items-center">
                <input
                  type="radio"
                  name="theme"
                  value="dark"
                  checked={settings.theme === 'dark'}
                  onChange={(e) => handleSettingChange('theme', e.target.value)}
                  className="w-4 h-4"
                />
                <span className="ml-2 text-gray-700">Dark</span>
              </label>
              <label className="flex items-center">
                <input
                  type="radio"
                  name="theme"
                  value="auto"
                  checked={settings.theme === 'auto'}
                  onChange={(e) => handleSettingChange('theme', e.target.value)}
                  className="w-4 h-4"
                />
                <span className="ml-2 text-gray-700">Auto</span>
              </label>
            </div>
          </div>
        </div>
      </Card>

      {/* Notifications */}
      <Card title="Notifications" icon={Bell} className="mb-6">
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <p className="font-medium text-gray-800">Push Notifications</p>
              <p className="text-sm text-gray-600">Receive push notifications</p>
            </div>
            <input
              type="checkbox"
              checked={settings.notifications}
              onChange={(e) => handleSettingChange('notifications', e.target.checked)}
              className="w-6 h-6 cursor-pointer"
            />
          </div>
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <p className="font-medium text-gray-800">Email Notifications</p>
              <p className="text-sm text-gray-600">Receive email updates</p>
            </div>
            <input
              type="checkbox"
              checked={settings.emailNotifications}
              onChange={(e) => handleSettingChange('emailNotifications', e.target.checked)}
              className="w-6 h-6 cursor-pointer"
            />
          </div>
        </div>
      </Card>

      {/* Security */}
      <Card title="Security" icon={Lock} className="mb-6">
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
            <div>
              <p className="font-medium text-gray-800">Two-Factor Authentication</p>
              <p className="text-sm text-gray-600">Add an extra layer of security</p>
            </div>
            <input
              type="checkbox"
              checked={settings.twoFactor}
              onChange={(e) => handleSettingChange('twoFactor', e.target.checked)}
              className="w-6 h-6 cursor-pointer"
            />
          </div>
          <button className="w-full px-4 py-2 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition font-medium">
            Change Password
          </button>
        </div>
      </Card>

      {/* Save Button */}
      <div className="flex justify-end gap-4">
        <button className="px-6 py-3 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition font-medium">
          Cancel
        </button>
        <button
          onClick={handleSave}
          className="flex items-center gap-2 px-6 py-3 bg-gradient-primary text-white rounded-lg hover:opacity-90 transition font-medium"
        >
          <Save size={20} />
          Save Changes
        </button>
      </div>
    </div>
  )
}

export default Settings
