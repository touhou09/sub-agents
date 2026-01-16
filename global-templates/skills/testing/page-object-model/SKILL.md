---
name: page-object-model
description: |
  Page Object Model pattern for E2E testing with Playwright.
  Encapsulates page selectors and actions into reusable classes.
  Trigger: "POM", "page object", "E2E test structure", "Playwright test"
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash(npx playwright:*)
  - Bash(pytest:*)
---

# Page Object Model Pattern

## Why POM?

```
Without POM:
├── test_login.py      → page.locator('#email').fill(...)
├── test_dashboard.py  → page.locator('#email').fill(...)  # 중복!
├── test_profile.py    → page.locator('#email').fill(...)  # 또 중복!
└── selector 변경 시 → 3개 파일 모두 수정 필요 😱

With POM:
├── pages/
│   └── login_page.py  → self.email_input = '#email'  # 한 곳에서 관리
├── tests/
│   ├── test_login.py      → login_page.fill_email(...)
│   ├── test_dashboard.py  → login_page.fill_email(...)
│   └── test_profile.py    → login_page.fill_email(...)
└── selector 변경 시 → login_page.py만 수정 ✨
```

## Directory Structure

```
tests/
├── pages/                    # Page Objects
│   ├── base_page.py         # 공통 기능
│   ├── login_page.py
│   ├── dashboard_page.py
│   └── components/          # 재사용 컴포넌트
│       ├── navbar.py
│       └── modal.py
├── tests/                   # 테스트 파일
│   ├── test_login.py
│   └── test_dashboard.py
├── fixtures/                # pytest fixtures
│   └── conftest.py
└── utils/                   # 유틸리티
    └── test_data.py
```

## Base Page Class

```python
# pages/base_page.py
from playwright.sync_api import Page, expect

class BasePage:
    def __init__(self, page: Page):
        self.page = page

    def navigate(self, path: str = ""):
        self.page.goto(f"{self.base_url}{path}")
        self.page.wait_for_load_state("networkidle")
        return self

    def get_title(self) -> str:
        return self.page.title()

    def take_screenshot(self, name: str):
        self.page.screenshot(path=f"/tmp/{name}.png")

    def wait_for_element(self, selector: str, timeout: int = 5000):
        self.page.wait_for_selector(selector, timeout=timeout)
```

## Page Object Example

```python
# pages/login_page.py
from pages.base_page import BasePage
from playwright.sync_api import Page, expect

class LoginPage(BasePage):
    base_url = "http://localhost:3000"

    # Selectors - 한 곳에서 관리
    SELECTORS = {
        "email": "#email",
        "password": "#password",
        "submit": "button[type='submit']",
        "error_message": "[data-testid='error-message']",
        "remember_me": "#remember-me",
    }

    def __init__(self, page: Page):
        super().__init__(page)
        self.navigate("/login")

    # Actions - 비즈니스 로직 캡슐화
    def fill_email(self, email: str):
        self.page.locator(self.SELECTORS["email"]).fill(email)
        return self

    def fill_password(self, password: str):
        self.page.locator(self.SELECTORS["password"]).fill(password)
        return self

    def click_submit(self):
        self.page.locator(self.SELECTORS["submit"]).click()
        return self

    def check_remember_me(self):
        self.page.locator(self.SELECTORS["remember_me"]).check()
        return self

    # Composite actions - 여러 액션 조합
    def login(self, email: str, password: str):
        """Complete login flow"""
        return (
            self.fill_email(email)
                .fill_password(password)
                .click_submit()
        )

    # Assertions - 검증 로직
    def expect_error_message(self, message: str):
        error = self.page.locator(self.SELECTORS["error_message"])
        expect(error).to_have_text(message)
        return self

    def expect_login_successful(self):
        expect(self.page).to_have_url("/dashboard")
        return self
```

## Component Objects

```python
# pages/components/navbar.py
from playwright.sync_api import Page

class Navbar:
    SELECTORS = {
        "logo": "[data-testid='logo']",
        "menu_button": "[data-testid='menu-toggle']",
        "user_dropdown": "[data-testid='user-dropdown']",
        "logout_button": "[data-testid='logout']",
    }

    def __init__(self, page: Page):
        self.page = page

    def open_user_menu(self):
        self.page.locator(self.SELECTORS["user_dropdown"]).click()
        return self

    def logout(self):
        self.open_user_menu()
        self.page.locator(self.SELECTORS["logout_button"]).click()
        return self
```

## Test Example

```python
# tests/test_login.py
import pytest
from pages.login_page import LoginPage
from pages.dashboard_page import DashboardPage

class TestLogin:
    def test_successful_login(self, page):
        login_page = LoginPage(page)

        login_page.login("user@example.com", "password123")
        login_page.expect_login_successful()

        dashboard = DashboardPage(page)
        dashboard.expect_welcome_message("Welcome, User!")

    def test_invalid_credentials(self, page):
        login_page = LoginPage(page)

        login_page.login("wrong@email.com", "wrongpass")
        login_page.expect_error_message("Invalid credentials")

    def test_remember_me(self, page):
        login_page = LoginPage(page)

        (login_page
            .fill_email("user@example.com")
            .fill_password("password123")
            .check_remember_me()
            .click_submit())

        # Verify cookie is set
        cookies = page.context.cookies()
        assert any(c["name"] == "remember_token" for c in cookies)
```

## Fixtures (conftest.py)

```python
# fixtures/conftest.py
import pytest
from playwright.sync_api import sync_playwright

@pytest.fixture(scope="session")
def browser():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        yield browser
        browser.close()

@pytest.fixture
def page(browser):
    context = browser.new_context()
    page = context.new_page()
    yield page
    context.close()

@pytest.fixture
def authenticated_page(page):
    """Pre-authenticated page for tests that need login"""
    from pages.login_page import LoginPage
    login_page = LoginPage(page)
    login_page.login("test@example.com", "testpass")
    return page
```

## TypeScript/Playwright Test

```typescript
// pages/login.page.ts
import { Page, Locator, expect } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.locator('#email');
    this.passwordInput = page.locator('#password');
    this.submitButton = page.locator('button[type="submit"]');
    this.errorMessage = page.locator('[data-testid="error-message"]');
  }

  async goto() {
    await this.page.goto('/login');
    await this.page.waitForLoadState('networkidle');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toHaveText(message);
  }
}
```

```typescript
// tests/login.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/login.page';

test.describe('Login', () => {
  test('successful login redirects to dashboard', async ({ page }) => {
    const loginPage = new LoginPage(page);
    await loginPage.goto();
    await loginPage.login('user@example.com', 'password123');

    await expect(page).toHaveURL('/dashboard');
  });
});
```

## Best Practices

### 1. Selector Strategy Priority
```python
# Best → Worst
"[data-testid='submit']"      # 1. data-testid (most stable)
"role=button[name='Submit']"  # 2. ARIA role
"#submit-button"              # 3. ID
".submit-btn"                 # 4. Class (avoid if possible)
"button:has-text('Submit')"   # 5. Text (localization issues)
```

### 2. Method Chaining
```python
# Fluent interface 패턴
login_page.fill_email("test@example.com") \
          .fill_password("pass123") \
          .check_remember_me() \
          .click_submit()
```

### 3. Avoid Exposing Selectors
```python
# ❌ Bad - 테스트에서 selector 직접 사용
page.locator("#email").fill("test@example.com")

# ✅ Good - Page Object 메서드 사용
login_page.fill_email("test@example.com")
```

### 4. Single Responsibility
```python
# ❌ Bad - 여러 페이지 로직 혼합
class UserPage:
    def login(self): ...
    def edit_profile(self): ...
    def view_orders(self): ...

# ✅ Good - 페이지별 분리
class LoginPage: ...
class ProfilePage: ...
class OrdersPage: ...
```

## When to Apply

| Trigger | Action |
|---------|--------|
| Writing E2E tests | Create Page Objects first |
| Same selector used 2+ times | Extract to Page Object |
| UI refactoring planned | Update Page Objects only |
| New page/feature | Create corresponding Page Object |

## Output Format

When applying POM skill:
```
### Applied Skills
- [x] page-object-model - created LoginPage, DashboardPage
- [x] Created pages/login_page.py
- [x] Created pages/dashboard_page.py
- [x] Tests in tests/test_login.py use Page Objects
```
