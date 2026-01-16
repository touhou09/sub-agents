"""Example: Login Page Object implementation."""
from playwright.sync_api import Page, expect

import sys
sys.path.insert(0, '..')
from templates.base_page import BasePage


class LoginPage(BasePage):
    """
    Page Object for Login Page.

    Demonstrates:
    - Centralized selectors
    - Fluent interface (method chaining)
    - Composite actions
    - Assertion methods
    """

    base_url = "http://localhost:3000"

    SELECTORS = {
        "email": "#email",
        "password": "#password",
        "submit": "button[type='submit']",
        "error_message": "[data-testid='error-message']",
        "remember_me": "#remember-me",
        "forgot_password": "a[href='/forgot-password']",
        "signup_link": "a[href='/signup']",
    }

    def __init__(self, page: Page, auto_navigate: bool = True):
        super().__init__(page)
        if auto_navigate:
            self.navigate("/login")

    # --- Input Actions ---

    def fill_email(self, email: str):
        """Fill email input field."""
        self.page.locator(self.SELECTORS["email"]).fill(email)
        return self

    def fill_password(self, password: str):
        """Fill password input field."""
        self.page.locator(self.SELECTORS["password"]).fill(password)
        return self

    def check_remember_me(self):
        """Check the remember me checkbox."""
        self.page.locator(self.SELECTORS["remember_me"]).check()
        return self

    def uncheck_remember_me(self):
        """Uncheck the remember me checkbox."""
        self.page.locator(self.SELECTORS["remember_me"]).uncheck()
        return self

    # --- Click Actions ---

    def click_submit(self):
        """Click the submit/login button."""
        self.page.locator(self.SELECTORS["submit"]).click()
        return self

    def click_forgot_password(self):
        """Click forgot password link."""
        self.page.locator(self.SELECTORS["forgot_password"]).click()
        return self

    def click_signup(self):
        """Click signup link."""
        self.page.locator(self.SELECTORS["signup_link"]).click()
        return self

    # --- Composite Actions ---

    def login(self, email: str, password: str, remember_me: bool = False):
        """
        Complete login flow.

        Args:
            email: User email
            password: User password
            remember_me: Whether to check remember me

        Returns:
            self for method chaining
        """
        self.fill_email(email)
        self.fill_password(password)
        if remember_me:
            self.check_remember_me()
        self.click_submit()
        return self

    def login_with_credentials(self, credentials: dict):
        """
        Login using credentials dictionary.

        Args:
            credentials: dict with 'email' and 'password' keys
        """
        return self.login(
            email=credentials.get("email", ""),
            password=credentials.get("password", ""),
            remember_me=credentials.get("remember_me", False)
        )

    # --- Assertions ---

    def expect_login_successful(self):
        """Assert login was successful (redirected to dashboard)."""
        expect(self.page).to_have_url(f"{self.base_url}/dashboard")
        return self

    def expect_error_message(self, message: str):
        """Assert error message is displayed."""
        error = self.page.locator(self.SELECTORS["error_message"])
        expect(error).to_be_visible()
        expect(error).to_have_text(message)
        return self

    def expect_on_login_page(self):
        """Assert we are on the login page."""
        expect(self.page).to_have_url(f"{self.base_url}/login")
        return self

    def expect_email_field_error(self):
        """Assert email field has validation error."""
        email_input = self.page.locator(self.SELECTORS["email"])
        expect(email_input).to_have_attribute("aria-invalid", "true")
        return self

    # --- Getters ---

    def get_error_message(self) -> str:
        """Get error message text."""
        return self.get_text(self.SELECTORS["error_message"])

    def is_remember_me_checked(self) -> bool:
        """Check if remember me is checked."""
        return self.page.locator(self.SELECTORS["remember_me"]).is_checked()


# --- Usage Example ---
if __name__ == "__main__":
    from playwright.sync_api import sync_playwright

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        # Method chaining example
        login_page = LoginPage(page)
        login_page \
            .fill_email("test@example.com") \
            .fill_password("password123") \
            .check_remember_me() \
            .click_submit()

        # Or use composite action
        # login_page.login("test@example.com", "password123", remember_me=True)

        browser.close()
