/**
 * Base Page Object class for Playwright tests (TypeScript).
 */
import { Page, Locator, expect } from '@playwright/test';

export abstract class BasePage {
  readonly page: Page;
  abstract readonly baseUrl: string;

  constructor(page: Page) {
    this.page = page;
  }

  async navigate(path: string = ''): Promise<void> {
    await this.page.goto(`${this.baseUrl}${path}`);
    await this.page.waitForLoadState('networkidle');
  }

  async getTitle(): Promise<string> {
    return this.page.title();
  }

  async getUrl(): Promise<string> {
    return this.page.url();
  }

  async takeScreenshot(name: string, fullPage: boolean = true): Promise<void> {
    await this.page.screenshot({
      path: `/tmp/${name}.png`,
      fullPage
    });
  }

  async waitForElement(selector: string, timeout: number = 5000): Promise<void> {
    await this.page.waitForSelector(selector, { timeout });
  }

  async waitForUrl(urlPattern: string | RegExp, timeout: number = 5000): Promise<void> {
    await this.page.waitForURL(urlPattern, { timeout });
  }

  async scrollToElement(selector: string): Promise<void> {
    await this.page.locator(selector).scrollIntoViewIfNeeded();
  }

  async isElementVisible(selector: string): Promise<boolean> {
    return this.page.locator(selector).isVisible();
  }

  async getText(selector: string): Promise<string> {
    return (await this.page.locator(selector).textContent()) ?? '';
  }

  async click(selector: string): Promise<void> {
    await this.page.locator(selector).click();
  }

  async fill(selector: string, value: string): Promise<void> {
    await this.page.locator(selector).fill(value);
  }

  async expectVisible(selector: string): Promise<void> {
    await expect(this.page.locator(selector)).toBeVisible();
  }

  async expectHidden(selector: string): Promise<void> {
    await expect(this.page.locator(selector)).toBeHidden();
  }

  async expectText(selector: string, text: string): Promise<void> {
    await expect(this.page.locator(selector)).toHaveText(text);
  }

  async expectUrl(path: string): Promise<void> {
    await expect(this.page).toHaveURL(`${this.baseUrl}${path}`);
  }
}
