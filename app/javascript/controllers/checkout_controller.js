import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["stockItem", "cartItems", "emptyCart", "formInputs", "cartTotal", "totalCount", "submitBtn", "form"]

  connect() {
    this.cart = new Map()
    this.updateCartDisplay()
  }

  addItem(event) {
    const item = event.currentTarget
    const stockId = item.dataset.stockId
    const stockName = item.dataset.stockName
    const maxQuantity = parseInt(item.dataset.stockQuantity)

    if (this.cart.has(stockId)) {
      const current = this.cart.get(stockId)
      if (current.quantity < maxQuantity) {
        current.quantity++
        this.cart.set(stockId, current)
      }
    } else {
      this.cart.set(stockId, {
        name: stockName,
        quantity: 1,
        maxQuantity: maxQuantity
      })
    }

    this.updateCartDisplay()
    this.flashItem(item)
  }

  flashItem(item) {
    item.classList.add('added')
    setTimeout(() => item.classList.remove('added'), 300)
  }

  removeItem(event) {
    const stockId = event.currentTarget.dataset.stockId
    this.cart.delete(stockId)
    this.updateCartDisplay()
  }

  incrementItem(event) {
    const stockId = event.currentTarget.dataset.stockId
    const item = this.cart.get(stockId)
    if (item && item.quantity < item.maxQuantity) {
      item.quantity++
      this.cart.set(stockId, item)
      this.updateCartDisplay()
    }
  }

  decrementItem(event) {
    const stockId = event.currentTarget.dataset.stockId
    const item = this.cart.get(stockId)
    if (item) {
      item.quantity--
      if (item.quantity <= 0) {
        this.cart.delete(stockId)
      } else {
        this.cart.set(stockId, item)
      }
      this.updateCartDisplay()
    }
  }

  clearCart() {
    this.cart.clear()
    this.updateCartDisplay()
  }

  updateCartDisplay() {
    const cartItemsEl = this.cartItemsTarget
    const formInputsEl = this.formInputsTarget

    // Clear previous content
    cartItemsEl.innerHTML = ''
    formInputsEl.innerHTML = ''

    let totalItems = 0

    if (this.cart.size === 0) {
      cartItemsEl.innerHTML = '<p class="empty-cart">Click items to add them to checkout</p>'
      this.cartTotalTarget.style.display = 'none'
      this.submitBtnTarget.disabled = true
    } else {
      this.cart.forEach((item, stockId) => {
        totalItems += item.quantity

        // Create cart item element
        const cartItem = document.createElement('div')
        cartItem.className = 'cart-item'
        cartItem.innerHTML = `
          <div class="cart-item-info">
            <span class="cart-item-name">${item.name}</span>
          </div>
          <div class="cart-item-controls">
            <button type="button" class="qty-btn" data-action="checkout#decrementItem" data-stock-id="${stockId}">−</button>
            <span class="cart-item-qty">${item.quantity}</span>
            <button type="button" class="qty-btn" data-action="checkout#incrementItem" data-stock-id="${stockId}" ${item.quantity >= item.maxQuantity ? 'disabled' : ''}>+</button>
            <button type="button" class="remove-btn" data-action="checkout#removeItem" data-stock-id="${stockId}">×</button>
          </div>
        `
        cartItemsEl.appendChild(cartItem)

        // Create hidden form inputs
        const stockIdInput = document.createElement('input')
        stockIdInput.type = 'hidden'
        stockIdInput.name = 'checkout_items[][customer_stock_id]'
        stockIdInput.value = stockId
        formInputsEl.appendChild(stockIdInput)

        const qtyInput = document.createElement('input')
        qtyInput.type = 'hidden'
        qtyInput.name = 'checkout_items[][quantity]'
        qtyInput.value = item.quantity
        formInputsEl.appendChild(qtyInput)
      })

      this.cartTotalTarget.style.display = 'flex'
      this.totalCountTarget.textContent = totalItems
      this.submitBtnTarget.disabled = false
    }
  }
}
