# TODO List - Pushup Record Keeper

## High Priority Tasks

### 1. Remove Widget Preview Section ✅ COMPLETE
- [x] Remove the "Home Screen Widget Preview" section from the main UI in `lib/main.dart`
- [x] This was only for development purposes and should be cleaned up
- [x] Keep the main counter interface but remove the circular preview container

### 2. Transition from "Counter" to "Record Keeper" Branding
- [ ] Update app terminology throughout the codebase
- [ ] Update UI text and labels:
  - [ ] Change "Current Session" to "Current Record"
  - [ ] Update motivational messages to focus on beating personal records
  - [ ] Update button text and descriptions
- [ ] Update documentation:
  - [ ] Update README.md to reflect record-keeping purpose
  - [ ] Update app description in `pubspec.yaml`
  - [ ] Update comments and variable names where appropriate
- [ ] Update Android strings:
  - [ ] Change app name in `android/app/src/main/res/values/strings.xml`
  - [ ] Update widget description from "Track your pushup progress" to record-focused text
- [ ] Consider app name change from "Pushup Counter" to "Pushup Record Keeper"

### 3. Improve Widget Preview in Widget Picker ✅ INVESTIGATION COMPLETE
**Root Cause Found**: The widget preview file `/android/app/src/main/res/drawable/widget_preview.xml` currently contains only a plain orange oval shape with no text.

- [ ] **Fix the widget preview drawable**:
  - [ ] Replace `/android/app/src/main/res/drawable/widget_preview.xml` with a proper preview
  - [ ] Create a preview that shows "Pushup Record" text with a sample number
  - [ ] Option A: Convert to a layer-list drawable with text overlay
  - [ ] Option B: Create a PNG preview image with proper text rendering
- [ ] **Files confirmed to exist**:
  - [x] `/android/app/src/main/res/xml/pushup_widget_info.xml` - Widget configuration (references preview)
  - [x] `/android/app/src/main/res/drawable/widget_preview.xml` - Current problematic preview
- [ ] **Current widget config**: Properly configured for resizable 120dp-200dp circular widget

### 4. Dynamic Theme Color Support
- [ ] Investigate using user's system theme color instead of hardcoded orange (#FF9800)
- [ ] Research Flutter's dynamic color support with Material You/Android 12+
- [ ] If system theme integration isn't possible:
  - [ ] Add color picker/theme selection in app settings
  - [ ] Allow widget color customization
  - [ ] Save theme preference in SharedPreferences
- [ ] Files to modify:
  - [ ] `lib/main.dart` - Theme configuration
  - [ ] `android/app/src/main/res/drawable/widget_background.xml` - Widget colors
  - [ ] `lib/pushup_service.dart` - Theme persistence
  - [ ] Widget provider for dynamic color updates

## Implementation Notes

### Widget Preview Investigation Needed
- Check if Android requires specific preview images or configuration
- Look into `android/app/src/main/res/xml/` for widget configuration files
- May need to add proper widget preview resources

### Theme System Research
- Investigate Material 3 dynamic theming capabilities
- Check if `home_widget` plugin supports dynamic colors
- Consider fallback options for older Android versions

### Code Quality
- [ ] Review and update variable names to reflect "record" vs "counter" terminology
- [ ] Update code comments and documentation
- [ ] Ensure consistent naming conventions

## Future Enhancements (Lower Priority)
- [ ] Add streak tracking (consecutive days with pushup records)
- [ ] Add goal setting functionality
- [ ] Consider workout history/calendar view
- [ ] Add sharing capabilities for achievements
- [ ] Widget size variations (small, medium, large)
