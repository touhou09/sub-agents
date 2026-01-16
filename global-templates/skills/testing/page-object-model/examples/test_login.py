"""Example: Tests using LoginPage Page Object."""
import pytest
from login_page import LoginPage


class TestLogin:
    """Login functionality tests using Page Object Model."""

    def test_successful_login(self, page):
        """Test that valid credentials lead to successful login."""
        login_page = LoginPage(page)

        login_page.login("user@example.com", "validpassword123")
        login_page.expect_login_successful()

    def test_invalid_email(self, page):
        """Test error message for invalid email."""
        login_page = LoginPage(page)

        login_page.login("invalid-email", "password123")
        login_page.expect_error_message("Invalid email format")

    def test_wrong_password(self, page):
        """Test error message for wrong password."""
        login_page = LoginPage(page)

        login_page.login("user@example.com", "wrongpassword")
        login_page.expect_error_message("Invalid credentials")

    def test_empty_fields(self, page):
        """Test validation for empty fields."""
        login_page = LoginPage(page)

        login_page.click_submit()
        login_page.expect_email_field_error()

    def test_remember_me_sets_cookie(self, page):
        """Test that remember me checkbox sets appropriate cookie."""
        login_page = LoginPage(page)

        login_page.login("user@example.com", "password123", remember_me=True)

        # Verify remember token cookie is set
        cookies = page.context.cookies()
        remember_cookie = next(
            (c for c in cookies if c["name"] == "remember_token"),
            None
        )
        assert remember_cookie is not None
        assert remember_cookie["expires"] > 0  # Has expiration

    def test_forgot_password_navigation(self, page):
        """Test forgot password link navigation."""
        login_page = LoginPage(page)

        login_page.click_forgot_password()

        from playwright.sync_api import expect
        expect(page).to_have_url("http://localhost:3000/forgot-password")

    def test_signup_navigation(self, page):
        """Test signup link navigation."""
        login_page = LoginPage(page)

        login_page.click_signup()

        from playwright.sync_api import expect
        expect(page).to_have_url("http://localhost:3000/signup")


class TestLoginWithFixtures:
    """Tests demonstrating fixture usage with Page Objects."""

    def test_login_with_test_user(self, page, test_user):
        """Test login using fixture-provided credentials."""
        login_page = LoginPage(page)

        login_page.login_with_credentials(test_user)
        login_page.expect_login_successful()

    def test_dashboard_after_login(self, authenticated_page):
        """Test dashboard access with pre-authenticated page."""
        # authenticated_page fixture already logged in
        from playwright.sync_api import expect
        expect(authenticated_page).to_have_url("http://localhost:3000/dashboard")


# --- Parametrized Tests ---

@pytest.mark.parametrize("email,password,expected_error", [
    ("", "password", "Email is required"),
    ("user@example.com", "", "Password is required"),
    ("invalid", "password", "Invalid email format"),
    ("user@example.com", "short", "Password too short"),
])
def test_validation_errors(page, email, password, expected_error):
    """Test various validation error scenarios."""
    login_page = LoginPage(page)

    login_page.fill_email(email)
    login_page.fill_password(password)
    login_page.click_submit()

    login_page.expect_error_message(expected_error)
