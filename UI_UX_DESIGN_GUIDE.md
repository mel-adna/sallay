# Sallay App - UI/UX Design System Guide

> A comprehensive design reference for building modern, accessible Flutter applications with clean aesthetics and excellent user experience.

## Table of Contents
- [Design Philosophy](#design-philosophy)
- [Color System](#color-system)
- [Typography](#typography)
- [Spacing & Layout](#spacing--layout)
- [Component Patterns](#component-patterns)
- [UI/UX Principles](#uiux-principles)
- [Dark Mode](#dark-mode)
- [Accessibility](#accessibility)

---

## Design Philosophy

**Minimalist & Purposeful**: Every element serves a clear purpose. No unnecessary decoration or complexity.

**User-First**: Prioritize user needs over technical constraints. Make the common case simple and the complex case possible.

**Consistent & Predictable**: Users should never be surprised by how things work. Use familiar patterns and consistent behaviors.

**Performance-Aware**: Beautiful design that doesn't compromise on speed or responsiveness.

---

## Color System

### Light Theme Colors

```dart
// Primary Brand Colors
Primary:     #00897B  (Teal 600) - Main actions, active states
Secondary:   #26A69A  (Teal 400) - Accents, highlights

// Backgrounds & Surfaces
Background:  #F5F5F5  (Grey 100) - App background
Surface:     #FFFFFF  (White)    - Cards, elevated components

// Text Colors
TextPrimary:    #212121  (Grey 900) - Headlines, body text
TextSecondary:  #757575  (Grey 600) - Secondary text, labels

// Semantic Colors
Error:    #D32F2F  (Red 700)   - Errors, destructive actions
Success:  #388E3C  (Green 700) - Success states, confirmations
```

### Dark Theme Colors

```dart
// Backgrounds
DarkBackground:        #000000  (Pure Black) - App background
DarkSurface:          #1C1C1E  (Dark Grey)  - Cards, surfaces
DarkSurfaceHighlight: #2C2C2E  (Lighter Grey) - Borders, dividers

// Text
DarkTextPrimary:   #FFFFFF  (White)
DarkTextSecondary: #8E8E93  (Grey)

// Accent (consistent across themes)
DarkAccent: #00897B  (Same as light primary for brand consistency)
```

### Color Usage Guidelines

**Do:**
- Use primary color sparingly for key actions (CTAs, active states)
- Use secondary color for less prominent elements (icons, subtle highlights)
- Maintain 4.5:1 contrast ratio for text (WCAG AA)
- Use semantic colors (error, success) consistently

**Don't:**
- Mix too many colors - stick to the palette
- Use pure black on pure white (use slightly off-white/off-black)
- Rely on color alone for information (add icons/text)

---

## Typography

### Font Family
**Google Fonts - Cairo**: Excellent for both Arabic and English, clean and modern.

```dart
textTheme: GoogleFonts.cairoTextTheme()
```

### Type Scale

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| **Display Large** | 57sp | Bold (700) | Hero headings |
| **Display Medium** | 45sp | Bold (700) | Main headings |
| **Display Small** | 36sp | Bold (700) | Section headings |
| **Headline Medium** | 28sp | Semi-bold (600) | Card titles |
| **Title Large** | 22sp | Semi-bold (600) | List item titles |
| **Body Large** | 16sp | Regular (400) | Primary body text |
| **Body Medium** | 14sp | Regular (400) | Secondary text |

### Typography Best Practices

1. **Hierarchy**: Use size and weight to create clear visual hierarchy
2. **Line Height**: 1.5x for body text, 1.2x for headings
3. **Line Length**: Max 75 characters for readability
4. **Alignment**: Left-align text (RTL for Arabic)
5. **Color**: Use text colors from palette (TextPrimary for body, TextSecondary for labels)

```dart
// Example: Card Title
Text(
  'Prayer Time',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.w600,
  ),
)
```

---

## Spacing & Layout

### Spacing Scale (8px base unit)

```dart
const spacing = {
  'xs':   4.0,   // Tiny gaps
  'sm':   8.0,   // Small gaps
  'md':   12.0,  // Medium gaps (between related items)
  'lg':   16.0,  // Large gaps (sections)
  'xl':   24.0,  // Extra large (screen padding)
  'xxl':  32.0,  // Major sections
  'xxxl': 48.0,  // Hero spacing
};
```

### Layout Guidelines

**Padding:**
- Screen edges: 24px (xl)
- Card interior: 16px (lg)
- Between list items: 12px (md)
- Between sections: 24-32px (xl-xxl)

**Border Radius:**
- Buttons: 30px (pill shape)
- Cards: 24px (rounded corners)
- Small elements: 12-16px
- Icons containers: 12px

**Example Usage:**
```dart
// Screen padding
padding: const EdgeInsets.all(24.0)

// Card padding
padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)

// Between items in list
const SizedBox(height: 12)

// Between sections
const SizedBox(height: 24)
```

---

## Component Patterns

### 1. Custom Settings Tile

A standardized tile for settings screens with icon, title, subtitle, and action.

```dart
Widget _SettingsTile({
  required IconData icon,
  required String title,
  String? subtitle,
  bool isSwitch = false,
  bool switchValue = false,
  ValueChanged<bool>? onChanged,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24),
          ),
          const SizedBox(width: 16),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ),
          ),
          // Trailing (Switch or Arrow)
          if (isSwitch)
            Switch(value: switchValue, onChanged: onChanged)
          else
            Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    ),
  );
}
```

**Key Features:**
- Icon wrapped in colored container (10% opacity of primary color)
- Bold title (FontWeight.w600)
- Proper spacing (16px padding, 12px icon container)
- Trailing indicator (arrow or switch)

### 2. Prayer Pill (Uniform Size Card)

Consistent-sized cards for displaying prayer information.

```dart
Widget _buildPrayerPill({
  required String name,
  required bool isDone,
  required bool isNext,
  required double width,
}) {
  return InkWell(
    onTap: () => _markAsPrayed(name),
    borderRadius: BorderRadius.circular(16),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,  // Fixed width for uniformity
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDone 
          ? primary.withOpacity(0.15) 
          : surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: isNext 
          ? Border.all(color: primary.withOpacity(0.5), width: 1)
          : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    ),
  );
}
```

**Key Features:**
- Uniform width (calculated from available space)
- Animated state changes (200ms)
- Visual feedback (border for active, background for done)
- Icon + Text layout with consistent spacing

### 3. Error State Screen

Full-screen error display with actionable recovery options.

```dart
Widget _buildErrorState() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error Title',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Error description explaining what went wrong.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _retry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    ),
  );
}
```

**Key Features:**
- Large icon (48px) with error color
- Clear hierarchy (title → description → action)
- Center-aligned text for focus
- Action button with icon for clarity

### 4. Loading State

```dart
// Simple centered loading
const Center(child: CircularProgressIndicator())

// Loading with message
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const CircularProgressIndicator(),
    const SizedBox(height: 16),
    Text('Loading...', style: bodyMedium),
  ],
)
```

---

## UI/UX Principles

### 1. **Progressive Disclosure**
Show only what's needed, when it's needed.

✅ Good: Onboarding → Location Setup → Home
❌ Bad: Everything on one overwhelming screen

### 2. **Instant Feedback**
Users should immediately see the result of their actions.

```dart
// Visual feedback on tap
InkWell(
  onTap: () => handleTap(),
  borderRadius: BorderRadius.circular(16),
  child: Container(...),
)

// State-based UI
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  color: isSelected ? primary : surface,
)
```

### 3. **Forgiveness & Confirmation**
Prevent mistakes with confirmations for destructive actions.

```dart
// Destructive action with confirmation
void _showDeleteConfirmation() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => _performDelete(),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('Delete'),
        ),
      ],
    ),
  );
}
```

### 4. **Clear Navigation**
Users should always know where they are and how to get back.

- Use `Navigator.pushReplacement` for flows (onboarding → location → home)
- Use `Navigator.pushAndRemoveUntil` for logout/reset scenarios
- Always provide back button or clear exit path

### 5. **Accessibility First**

```dart
// Semantic labels for screen readers
IconButton(
  icon: Icon(Icons.settings),
  onPressed: _openSettings,
  tooltip: 'Settings',  // Screen reader will announce this
)

// Sufficient touch targets (minimum 48x48)
InkWell(
  child: Container(
    padding: EdgeInsets.all(16),  // Ensures 48+ touch target
    child: Icon(Icons.close),
  ),
)

// High contrast text
Text(
  'Important',
  style: TextStyle(
    color: textPrimary,  // 4.5:1 contrast minimum
    fontWeight: FontWeight.w600,
  ),
)
```

---

## Dark Mode

### Support Both Themes
Always design with both light and dark modes in mind.

```dart
// Use theme colors, not hardcoded colors
color: Theme.of(context).colorScheme.primary  // ✅ Adapts to theme
color: Colors.blue  // ❌ Same in both themes

// Check current brightness
final isDark = Theme.of(context).brightness == Brightness.dark;
```

### Dark Mode Best Practices

1. **Reduce contrast**: Pure white on pure black is harsh
   - Use #1C1C1E instead of #000000 for surfaces
   - Use #FFFFFF with slight opacity for text

2. **Maintain brand colors**: Keep primary color same across themes
   - Sallay uses #00897B in both light and dark

3. **Test frequently**: View every screen in both modes

---

## Accessibility

### Color Contrast
- **WCAG AA**: Minimum 4.5:1 for normal text, 3:1 for large text
- **WCAG AAA**: 7:1 for normal text, 4.5:1 for large text

### Touch Targets
- Minimum: 48x48 dp
- Recommended: 56x56 dp for primary actions

### Screen Reader Support
```dart
Semantics(
  label: 'Settings button',
  hint: 'Opens application settings',
  child: IconButton(...),
)
```

### Keyboard Navigation
Ensure all interactive elements are focusable and navigable via keyboard/assistive touch.

---

## Quick Reference: Common Patterns

### Button Styles
```dart
// Primary Action
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  ),
  child: Text('Continue'),
)

// Secondary Action
OutlinedButton(
  style: OutlinedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  ),
  child: Text('Cancel'),
)

// Destructive Action
TextButton(
  style: TextButton.styleFrom(foregroundColor: Colors.red),
  child: Text('Delete'),
)
```

### Card Style
```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: Theme.of(context).dividerColor,
      width: 1,
    ),
  ),
  child: child,
)
```

### Dialog Style
```dart
Dialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Title', style: titleLarge),
        SizedBox(height: 16),
        Text('Content', style: bodyMedium),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(child: Text('Cancel')),
            SizedBox(width: 8),
            ElevatedButton(child: Text('Confirm')),
          ],
        ),
      ],
    ),
  ),
)
```

---

## Summary Checklist

When building a new screen or component, ask:

- [ ] Does it use colors from the app's color palette?
- [ ] Is the typography scale consistent (Cairo font, proper weights)?
- [ ] Are spacing values multiples of 8px?
- [ ] Does it work in both light and dark mode?
- [ ] Are touch targets at least 48x48dp?
- [ ] Is there sufficient color contrast (4.5:1 minimum)?
- [ ] Does it provide instant visual feedback?
- [ ] Is there keyboard/screen reader support?
- [ ] Are destructive actions confirmed?
- [ ] Is the navigation clear and predictable?

---

**Built with ❤️ using Flutter**

For questions or suggestions, refer to the actual implementation in `/lib/core/theme/` and `/lib/ui/` folders.
