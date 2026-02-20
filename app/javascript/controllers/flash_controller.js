import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { message: String, type: String }

  connect() {
    this.showToast()
  }

  showToast() {
    const bgColor = this.typeValue === "success" ? "#2ecc71" : "#e74c3c"
    
    // You can replace this with a call to Toastify or SweetAlert
    // Example using a simple alert for testing:
    console.log(`Toast (${this.typeValue}): ${this.messageValue}`)
    
    // Logic to show a floating div:
    const toastDiv = document.createElement("div")
    toastDiv.textContent = this.messageValue
    toastDiv.style.cssText = `position:fixed; top:20px; right:20px; background:${bgColor}; color:white; padding:15px; border-radius:8px; z-index:9999; box-shadow: 0 4px 6px rgba(0,0,0,0.1);`
    
    document.body.appendChild(toastDiv)
    
    setTimeout(() => { toastDiv.remove() }, 3000)
  }
}
