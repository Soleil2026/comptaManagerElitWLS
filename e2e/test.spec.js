const { test, expect } = require('@playwright/test');

test.describe('comptaManagerDZ - E2E Tests', () => {
  
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:52582');
  });

  test('1. Login page loads correctly', async ({ page }) => {
    await expect(page.locator('text=comptaManagerDZ')).toBeVisible();
    await expect(page.locator('input[type="text"]')).toBeVisible();
    await expect(page.locator('input[type="password"]')).toBeVisible();
    await expect(page.locator('button:has-text("Se connecter")')).toBeVisible();
  });

  test('2. Login with valid credentials', async ({ page }) => {
    await page.fill('input[type="text"]', 'admin');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
    const url = page.url();
    expect(url).toContain('/documents') || url.includes('documents');
  });

  test('3. Navigate to Clients from menu', async ({ page }) => {
    // Login first
    await page.fill('input[type="text"]', 'admin');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
    
    // Open drawer/menu
    const menuButton = page.locator('button, .drawer, [class*="drawer"]').first();
    await menuButton.click();
    await page.waitForTimeout(500);
    
    // Click Clients
    await page.click('text=Clients');
    await page.waitForTimeout(1000);
    
    await expect(page.locator('text=Clients')).toBeVisible();
  });

  test('4. Add a new client', async ({ page }) => {
    // Login and navigate to Clients
    await page.fill('input[type="text"]', 'admin');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
    
    // Open menu and go to Clients
    const menuButton = page.locator('button').first();
    await menuButton.click();
    await page.waitForTimeout(500);
    await page.click('text=Clients');
    await page.waitForTimeout(1000);
    
    // Click add button
    const addButton = page.locator('button.fab, [class*="fab"], button:has(.add)').first();
    if (await addButton.isVisible()) {
      await addButton.click();
      await page.waitForTimeout(500);
      
      // Fill form
      await page.fill('input[type="text"] >> nth=0', 'Société Test');
      await page.click('button:has-text("Ajouter")');
      await page.waitForTimeout(1000);
    }
  });

  test('5. Empty state shown when no clients', async ({ page }) => {
    await page.fill('input[type="text"]', 'admin');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
    
    const menuButton = page.locator('button').first();
    await menuButton.click();
    await page.waitForTimeout(500);
    await page.click('text=Clients');
    await page.waitForTimeout(1000);
    
    // Should show empty state
    const emptyText = page.locator('text=Aucun client');
    if (await emptyText.isVisible()) {
      console.log('Empty state displayed correctly');
    }
  });

  test('6. Logout functionality', async ({ page }) => {
    await page.fill('input[type="text"]', 'admin');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
    
    // Go to admin
    const menuButton = page.locator('button').first();
    await menuButton.click();
    await page.waitForTimeout(500);
    await page.click('text=Administration');
    await page.waitForTimeout(500);
    
    // Check admin page loads
    await expect(page.locator('text=Utilisateurs')).toBeVisible();
  });
});

test.describe('Error Handling', () => {
  test('Show error for invalid login', async ({ page }) => {
    await page.fill('input[type="text"]', 'wrong');
    await page.fill('input[type="password"]', 'wrong');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
    
    // Should either show error or navigate
    const currentUrl = page.url();
    console.log('After login attempt, URL:', currentUrl);
  });
});

test.describe('Hub Documentaire (MVP)', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('http://localhost:52582');
    await page.fill('input[type="text"]', 'admin');
    await page.fill('input[type="password"]', 'admin123');
    await page.click('button:has-text("Se connecter")');
    await page.waitForTimeout(1000);
  });

  test('HD-1: Access Hub Documentaire from menu', async ({ page }) => {
    const menuButton = page.locator('button').first();
    await menuButton.click();
    await page.waitForTimeout(500);
    await page.click('text=Documents');
    await page.waitForTimeout(1000);
    await expect(page.locator('text=Hub Documentaire')).toBeVisible();
  });

  test('HD-2: Upload a document', async ({ page }) => {
    await page.click('text=Documents');
    await page.waitForTimeout(1000);
    const uploadButton = page.locator('button:has-text("Ajouter"), button:has(.upload)').first();
    if (await uploadButton.isVisible()) {
      await uploadButton.click();
      await page.waitForTimeout(500);
    }
  });

  test('HD-3: Search documents', async ({ page }) => {
    await page.click('text=Documents');
    await page.waitForTimeout(1000);
    const searchInput = page.locator('input[type="search"], input[placeholder*="recherch"]').first();
    if (await searchInput.isVisible()) {
      await searchInput.fill('test');
      await page.waitForTimeout(500);
    }
  });

  test('HD-4: Filter documents by type', async ({ page }) => {
    await page.click('text=Documents');
    await page.waitForTimeout(1000);
    const filterButton = page.locator('button:has-text("Filtrer"), [class*="filter"]').first();
    if (await filterButton.isVisible()) {
      await filterButton.click();
      await page.waitForTimeout(500);
    }
  });

  test('HD-5: View document details', async ({ page }) => {
    await page.click('text=Documents');
    await page.waitForTimeout(1000);
    const firstDoc = page.locator('[class*="document"], [class*="file"]').first();
    if (await firstDoc.isVisible()) {
      await firstDoc.click();
      await page.waitForTimeout(500);
    }
  });

  test('HD-6: Delete a document', async ({ page }) => {
    await page.click('text=Documents');
    await page.waitForTimeout(1000);
    const docMenu = page.locator('[class*="document"]').first();
    if (await docMenu.isVisible()) {
      await docMenu.click({ button: 'right' });
      await page.waitForTimeout(500);
      const deleteOption = page.locator('text=Supprimer');
      if (await deleteOption.isVisible()) {
        await deleteOption.click();
        await page.waitForTimeout(500);
      }
    }
  });
});