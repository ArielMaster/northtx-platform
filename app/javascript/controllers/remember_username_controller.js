import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="remember-username"
export default class extends Controller {
  static targets = ["email", "checkbox"]

  connect() {
    const savedEmail = localStorage.getItem("savedEmail")

    if (savedEmail) {
      this.emailTarget.value = savedEmail
      this.checkboxTarget.checked = true
    }
  }

  toggle() {
    if (this.checkboxTarget.checked) {
      localStorage.setItem("savedEmail", this.emailTarget.value)
    } else {
      localStorage.removeItem("savedEmail")
    }
  }

  update() {
    if (this.checkboxTarget.checked) {
      localStorage.setItem("savedEmail", this.emailTarget.value)
    }
  }
}
