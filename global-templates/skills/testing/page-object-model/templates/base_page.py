"""Base Page Object class for Playwright tests."""
from playwright.sync_api import Page, expect


class BasePage:
    """Base class for all Page Objects."""

    base_url: str = "http://localhost:3000"

    def __init__(self, page: Page):
        self.page = page

    def navigate(self, path: str = ""):
        """Navigate to a path relative to base_url."""
        self.page.goto(f"{self.base_url}{path}")
        self.page.wait_for_load_state("networkidle")
        return self

    def get_title(self) -> str:
        """Get page title."""
        return self.page.title()

    def get_url(self) -> str:
        """Get current URL."""
        return self.page.url

    def take_screenshot(self, name: str, full_page: bool = True):
        """Take a screenshot."""
        self.page.screenshot(path=f"/tmp/{name}.png", full_page=full_page)
        return self

    def wait_for_element(self, selector: str, timeout: int = 5000):
        """Wait for an element to be visible."""
        self.page.wait_for_selector(selector, timeout=timeout)
        return self

    def wait_for_url(self, url_pattern: str, timeout: int = 5000):
        """Wait for URL to match pattern."""
        self.page.wait_for_url(url_pattern, timeout=timeout)
        return self

    def scroll_to_element(self, selector: str):
        """Scroll element into view."""
        self.page.locator(selector).scroll_into_view_if_needed()
        return self

    def is_element_visible(self, selector: str) -> bool:
        """Check if element is visible."""
        return self.page.locator(selector).is_visible()

    def get_text(self, selector: str) -> str:
        """Get text content of an element."""
        return self.page.locator(selector).text_content() or ""
