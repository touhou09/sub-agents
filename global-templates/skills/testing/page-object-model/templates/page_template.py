"""Template for creating new Page Objects."""
from playwright.sync_api import Page, expect
from .base_page import BasePage


class ExamplePage(BasePage):
    """
    Page Object for Example Page.

    Usage:
        page = ExamplePage(playwright_page)
        page.do_something()
    """

    # Selectors - centralized selector management
    SELECTORS = {
        "header": "[data-testid='page-header']",
        "main_content": "[data-testid='main-content']",
        "submit_button": "button[type='submit']",
        "error_message": "[data-testid='error-message']",
        "success_message": "[data-testid='success-message']",
    }

    def __init__(self, page: Page):
        super().__init__(page)
        # Optionally navigate on init
        # self.navigate("/example")

    # --- Actions ---

    def click_submit(self):
        """Click the submit button."""
        self.page.locator(self.SELECTORS["submit_button"]).click()
        return self

    def fill_form(self, **fields):
        """
        Fill form fields dynamically.

        Usage:
            page.fill_form(email="test@example.com", name="John")
        """
        for field_name, value in fields.items():
            selector = self.SELECTORS.get(field_name)
            if selector:
                self.page.locator(selector).fill(value)
        return self

    # --- Assertions ---

    def expect_header_text(self, text: str):
        """Assert header contains expected text."""
        header = self.page.locator(self.SELECTORS["header"])
        expect(header).to_contain_text(text)
        return self

    def expect_error_message(self, message: str):
        """Assert error message is displayed."""
        error = self.page.locator(self.SELECTORS["error_message"])
        expect(error).to_be_visible()
        expect(error).to_have_text(message)
        return self

    def expect_success_message(self, message: str):
        """Assert success message is displayed."""
        success = self.page.locator(self.SELECTORS["success_message"])
        expect(success).to_be_visible()
        expect(success).to_have_text(message)
        return self

    def expect_url(self, path: str):
        """Assert current URL matches expected path."""
        expect(self.page).to_have_url(f"{self.base_url}{path}")
        return self

    # --- Getters ---

    def get_header_text(self) -> str:
        """Get header text content."""
        return self.get_text(self.SELECTORS["header"])

    def has_error(self) -> bool:
        """Check if error message is visible."""
        return self.is_element_visible(self.SELECTORS["error_message"])
