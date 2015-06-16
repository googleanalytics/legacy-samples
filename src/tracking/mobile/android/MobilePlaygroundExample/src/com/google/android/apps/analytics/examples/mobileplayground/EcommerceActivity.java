// Copyright 2011 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package com.google.android.apps.analytics.examples.mobileplayground;

import com.google.android.apps.analytics.GoogleAnalyticsTracker;
import com.google.android.apps.analytics.Item;
import com.google.android.apps.analytics.Transaction;
import com.google.android.apps.analytics.examples.mobileplayground.MobilePlayground.UserInputException;

import android.app.Activity;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnKeyListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

public class EcommerceActivity extends Activity {

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.ecommerce);

    setUniqueOrderId();
    calculate();

    setupAutoCalculate(R.id.item1Quantity);
    setupAutoCalculate(R.id.item1Price);
    setupAutoCalculate(R.id.item2Quantity);
    setupAutoCalculate(R.id.item2Price);

    final Button sendButton = (Button) findViewById(R.id.ecommerceSend);
    sendButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        sendEcommerce();
      }
    });

    final Button cancelButton = (Button) findViewById(R.id.ecommerceCancel);
    cancelButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        cancelEcommerce();
      }
    });

    final Button dispatchButton = (Button) findViewById(R.id.ecommerceDispatch);
    dispatchButton.setOnClickListener(new OnClickListener() {
      @Override
      public void onClick(View v) {
        // Manually start a dispatch (Unnecessary if the tracker has a dispatch interval)
        MobilePlayground.getTracker().dispatch();
      }
    });
  }

  @Override
  public void onResume() {
    super.onResume();

    // Disable buttons until tracker is set
    boolean enabled = MobilePlayground.isTrackerSet();
    ((Button) findViewById(R.id.ecommerceSend)).setEnabled(enabled);
    ((Button) findViewById(R.id.ecommerceCancel)).setEnabled(enabled);
    ((Button) findViewById(R.id.ecommerceDispatch)).setEnabled(enabled);
  }

  private void sendEcommerce() {
    GoogleAnalyticsTracker tracker = MobilePlayground.getTracker();
    try {
      // Queue Ecommerce transaction and items then send them all
      tracker.addTransaction(createTransation());
      tracker.addItem(createItem(1));
      tracker.addItem(createItem(2));
      tracker.trackTransactions();
    } catch (UserInputException e){
      // Clear out pending Ecommerce transaction and items that might have been added
      tracker.clearTransactions();
      Toast.makeText(this, e.getMessage(), Toast.LENGTH_SHORT).show();
    }
    setUniqueOrderId();
  }

  private void cancelEcommerce() {
    // Clear out pending Ecommerce transaction and items. Since no data has actually been set,
    // it's provided here only to demonstrate how to use it (it's unnecessary in this case).
    MobilePlayground.getTracker().clearTransactions();
  }

  private Transaction createTransation() throws UserInputException {
    Transaction.Builder transaction = new Transaction.Builder(
        getOrderId(),
        getTotalOrder());
    String storeName = getStoreName();
    if (storeName != null) {
      transaction.setStoreName(storeName);
    }
    Double tax = getTotalTax();
    if (tax != null) {
      transaction.setTotalTax(tax);
    }
    Double shipping = getShippingCost();
    if (shipping != null) {
      transaction.setShippingCost(shipping);
    }
    return transaction.build();
  }

  private Item createItem(int index) throws UserInputException {
    Item.Builder item = new Item.Builder(
        getOrderId(),
        getItemSku(index),
        getItemPrice(index),
        getItemQuantity(index));
    String itemName = getItemName(index);
    if (itemName != null) {
      item.setItemName(itemName);
    }
    String itemCategory = getItemCategory(index);
    if (itemCategory != null) {
      item.setItemCategory(itemCategory);
    }
    return item.build();
  }

  private double calculate() {
    double item1Total = getItemQuantity(1) * getItemPrice(1);
    ((TextView) findViewById(R.id.item1Total)).setText(Double.toString(item1Total));
    double item2Total = getItemQuantity(2) * getItemPrice(2);
    ((TextView) findViewById(R.id.item2Total)).setText(Double.toString(item2Total));
    double itemTotal = item1Total + item2Total;
    ((TextView) findViewById(R.id.itemTotal)).setText(Double.toString(itemTotal));
    return itemTotal;
  }

  private void setUniqueOrderId() {
    final EditText orderIdButton = (EditText) findViewById(R.id.orderId);
    orderIdButton.setText(getString(R.string.orderId) + System.currentTimeMillis());
  }

  private void setupAutoCalculate(int editTextId) {
    final EditText editText = (EditText) findViewById(editTextId);
    editText.setOnKeyListener(new OnKeyListener() {
      @Override
      public boolean onKey(View v, int keyCode, KeyEvent event) {
        calculate();
        return false;
      }
    });
  }

  private String getStoreName() {
    String storeName = ((EditText) findViewById(R.id.storeName)).getText().toString().trim();
    if (storeName.length() == 0) {
      return null;
    }
    return storeName;
  }

  private String getOrderId() throws UserInputException {
    String orderId = ((EditText) findViewById(R.id.orderId)).getText().toString().trim();
    if (orderId.length() == 0) {
      throw new UserInputException(getString(R.string.orderIdWarning));
    }
    return orderId;
  }

  private Double getTotalOrder() {
    return Double.valueOf(((TextView) findViewById(R.id.itemTotal)).getText().toString());
  }

  private Double getTotalTax() {
    String tax = ((EditText) findViewById(R.id.totalTax)).getText().toString().trim();
    if (tax.length() == 0) {
      return null;
    }
    return Double.valueOf(tax);
  }

  private Double getShippingCost() {
    String shipping = ((EditText) findViewById(R.id.shippingCost)).getText().toString().trim();
    if (shipping.length() == 0) {
      return null;
    }
    return Double.valueOf(shipping);
  }

  private String getItemName(int index) {
    int buttonId = index == 1 ? R.id.item1Name : R.id.item2Name;
    String name = ((EditText) findViewById(buttonId)).getText().toString().trim();
    if (name.length() == 0) {
      return null;
    }
    return name;
  }

  private String getItemCategory(int index) {
    int buttonId = index == 1 ? R.id.item1Category : R.id.item2Category;
    String name = ((EditText) findViewById(buttonId)).getText().toString().trim();
    if (name.length() == 0) {
      return null;
    }
    return name;
  }

  private String getItemSku(int index) throws UserInputException {
    int buttonId = index == 1 ? R.id.item1Sku : R.id.item2Sku;
    String sku = ((EditText) findViewById(buttonId)).getText().toString().trim();
    if (sku.length() == 0) {
      int warningId = index == 1 ? R.string.item1SkuWarning : R.string.item2SkuWarning;
      throw new UserInputException(getString(warningId));
    }
    return sku;
  }

  private long getItemQuantity(int index) {
    int buttonId = index == 1 ? R.id.item1Quantity : R.id.item2Quantity;
    String quantity = ((EditText) findViewById(buttonId)).getText().toString().trim();
    if (quantity.length() == 0) {
      return 0;
    }
    return Long.valueOf(quantity);
  }

  private double getItemPrice(int index) {
    int buttonId = index == 1 ? R.id.item1Price : R.id.item2Price;
    String quantity = ((EditText) findViewById(buttonId)).getText().toString().trim();
    if (quantity.length() == 0) {
      return 0.0;
    }
    return Double.valueOf(quantity);
  }
}
