import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["banner"]

  accept() {
    this.animateAndRemove(() => {
      fetch("/cookie_consent/accept", { method: "POST" })
    })
  }

  reject() {
    this.animateAndRemove()
  }

  animateAndRemove(callback = null) {
    this.bannerTarget.classList.add("animate-fadeSlideOut")

    setTimeout(() => {
      if (callback) callback()
      this.bannerTarget.remove()
    }, 600)
  }
}
