/**
 * Created by AlexGeorge on 6/4/17.
 */

$(function () {
    $('.alert-box').click(function(e){
        e.preventDefault();
        alert('hello world');
        console.log('test');
    });
});