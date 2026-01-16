"""Pytest fixtures for Playwright tests."""
import pytest
from playwright.sync_api import sync_playwright, Browser, Page, BrowserContext


@pytest.fixture(scope="session")
def browser() -> Browser:
    """Create a browser instance for the test session."""
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        yield browser
        browser.close()


@pytest.fixture(scope="function")
def context(browser: Browser) -> BrowserContext:
    """Create a new browser context for each test."""
    context = browser.new_context(
        viewport={"width": 1280, "height": 720},
        locale="en-US",
    )
    yield context
    context.close()


@pytest.fixture(scope="function")
def page(context: BrowserContext) -> Page:
    """Create a new page for each test."""
    page = context.new_page()
    yield page
    page.close()


@pytest.fixture(scope="function")
def authenticated_page(page: Page) -> Page:
    """
    Provide a pre-authenticated page.

    Customize this fixture to match your authentication flow.
    """
    from pages.login_page import LoginPage

    login_page = LoginPage(page)
    login_page.login(
        email="test@example.com",
        password="testpassword123"
    )
    return page


@pytest.fixture(scope="session")
def test_user():
    """Provide test user credentials."""
    return {
        "email": "test@example.com",
        "password": "testpassword123",
        "name": "Test User",
    }


# --- Hooks ---

def pytest_configure(config):
    """Configure pytest markers."""
    config.addinivalue_line("markers", "slow: marks tests as slow")
    config.addinivalue_line("markers", "smoke: marks tests as smoke tests")


@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    """Take screenshot on test failure."""
    outcome = yield
    report = outcome.get_result()

    if report.when == "call" and report.failed:
        page = item.funcargs.get("page")
        if page:
            screenshot_path = f"/tmp/failure_{item.name}.png"
            page.screenshot(path=screenshot_path, full_page=True)
            print(f"\nScreenshot saved: {screenshot_path}")
