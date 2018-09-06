// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

const MAX_FILE_SIZE = 4000;
const ACCEPTED_FILE_TYPES = ['test', 'test2'];

let validations = () => {
    let photoUpload = document.getElementById("user_avatar").files
    alert(photoUpload.length + " - " + photoUpload[0].size);
    if(photoUpload.length > 0) {
        valFileSize(photoUpload);
        // valIfPhoto(photoUpload);
    }
};

let valFileSize = (photo) => {
        if(photo[0].size > MAX_FILE_SIZE) {
            alert("File is too big, please use a photo with size below 4MB");
            event.preventDefault();
            event.stopPropagation();
        }
};

let valIfPhoto = (photo) => {
        if(photo[0].size > MAX_FILE_SIZE) {
            alert("File size is too large");
            event.preventDefault();
            event.stopPropagation();
        }
};

window.addEventListener("turbolinks:load", () => {
    let forms = document.getElementById('edit_user');
    if(typeof(forms) != 'undefined' && forms != null) {
        forms.addEventListener("submit", validations);
    }
});
