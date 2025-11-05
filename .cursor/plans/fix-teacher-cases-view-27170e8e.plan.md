<!-- 27170e8e-8c9c-4662-ab18-ebdf2b817544 f12e9aea-63a4-4be0-bcde-3894cd5bd979 -->
# Debug Teacher Cases View Issue

## Problem

Teachers still cannot see student-reported cases after initial implementation.

## Debugging Strategy

### 1. Add Comprehensive Logging

**Files to modify:**

- `lib/core/network/api_client.dart` - Log all requests with headers (masked)
- `lib/core/network/auth_header_provider.dart` - Log header construction
- `lib/features/cases/data/repositories/case_repository.dart` - Log responses

### 2. Verify Session Management

**File:** `lib/features/authentication/presentation/pages/teacher_login_page.dart`

- Verify school_id is present in login response
- Log sessionid after login
- Validate session is saved correctly

### 3. Add Debug UI

**File:** `lib/features/cases/presentation/pages/case_list_page.dart`

- Show debug info in development mode
- Display session status
- Show API response preview

### 4. Test Alternative Auth Method

If Cookie header doesn't work on Android:

- Try sending sessionid as Authorization header
- Test with X-Session-ID header

## Implementation

Add debug prints to trace:

1. Login response (school_id present?)
2. Session storage (sessionid saved?)
3. Request headers (Cookie sent correctly?)
4. API response (what does backend return?)

## Success

Identify exact failure point and fix accordingly.

### To-dos

- [ ] Add comprehensive debug logging to CaseRepository.getCases() including headers, raw response, and parsing steps
- [ ] Enhance CaseListPage to show detailed errors and empty state messages with debug info
- [ ] Add debug logging to AuthHeaderProvider to verify Cookie header construction
- [ ] Test the changes with a teacher account and verify cases are displayed correctly