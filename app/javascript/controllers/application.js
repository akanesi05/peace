import { Application } from "@hotwired/stimulus"
import { Autocomplete } from 'stimulus-autocomplete' 
console.log('hello!');
const application = Application.start()
application.register('autocomplete', Autocomplete)  

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
