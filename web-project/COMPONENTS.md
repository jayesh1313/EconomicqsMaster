# Components Library

This project includes reusable React components:

## UI Components

### Navbar
Located in `src/components/Navbar.jsx`
- User dropdown menu
- Notification bell with badge
- Responsive design

### Sidebar
Located in `src/components/Sidebar.jsx`
- Collapsible navigation
- Active route highlighting
- Gradient background
- Dynamic menu items

### Cards
Located in `src/components/Card.jsx`
- Reusable container component
- Icon support
- Title section
- Hover effects

### StatCard
Located in `src/components/StatCard.jsx`
- Shows statistics with trends
- Up/down indicators
- Icon support
- Responsive layout

### Charts
Located in `src/components/ChartComponent.jsx`
- LineChartComponent - Line charts with trends
- BarChartComponent - Bar charts for metrics
- PieChartComponent - Pie charts for distributions

### Alert
Located in `src/components/Alert.jsx`
- Info, success, warning, error variants
- Icon support
- Custom styling

### Dropdown
Located in `src/components/Dropdown.jsx`
- Customizable dropdown menu
- Icon support
- Selection handling

### Modal
Located in `src/components/Modal.jsx`
- Overlay modal dialog
- Confirm/Cancel buttons
- Customizable content

### Loading
Located in `src/components/Loading.jsx`
- Animated loading spinner
- Fullscreen or inline mode
- Custom message

### Badge
Located in `src/components/Badge.jsx`
- Multiple variants (default, primary, success, warning, danger)
- Size options (sm, md, lg)
- Lightweight component

### Button
Located in `src/components/Button.jsx`
- Multiple variants
- Size options
- Full-width support
- Disabled state
- Customizable styling

## Usage Examples

```jsx
import StatCard from './components/StatCard'
import Card from './components/Card'
import Alert from './components/Alert'
import Button from './components/Button'
import Badge from './components/Badge'

// StatCard
<StatCard 
  title="Revenue"
  value="$45,230"
  change="+12.5"
  icon={TrendingUp}
  trend="up"
/>

// Alert
<Alert 
  type="success"
  title="Success"
  message="Operation completed successfully"
/>

// Button
<Button variant="primary" size="lg" fullWidth>
  Submit
</Button>

// Badge
<Badge label="Active" variant="success" size="md" />
```

## Styling

All components use:
- Tailwind CSS for styling
- Lucide React for icons
- Responsive design
- Consistent color scheme

## Customization

Components are built with:
- Props for customization
- CSS classes for styling
- Variants for different styles
- Size options

All components are modular and can be used independently or combined.
