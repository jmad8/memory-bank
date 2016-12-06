// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-datepicker
//= require turbolinks
//= require_tree .

$(document).ready(function () {

	$('#bookmarklet').on('click', function(){
		function loadScript(){
			var script=document.createElement('script');
			script.setAttribute('type','text/javascript');
			script.setAttribute('charset','UTF-8');
			script.setAttribute('async','true');
			script.setAttribute('src','https://sdk.spritzinc.com/js/2.0/bookmarklet/js/SpritzletOuter.js?' + (new Date().getTime()).toString().substring(0,7));
			document.documentElement.appendChild(script);
			setTimeout(function(){
				if(Spritzlet.timedOut===true){
					$("#spritz-error").show();
				}
			},3000);
			script.onload=function(){
				Spritzlet.timedOut=false;
				var rs=script.readyState;
				if(!rs || rs==='loaded' || rs==='complete'){
					script.onload=script.onreadystatechange=null;
					Spritzlet.init();
				}
			};
		}
		try{
			window.Spritzlet=window.Spritzlet ||{};
			window.Spritzlet={origin:window.location.protocol + '//' + window.location.host,loaderVersion:1.1,timedOut:true};
			loadScript();
		}
		catch (err){
			$("#spritz-error").show();
		}
	});

	$('.date-picker').datepicker({
		format: "yyyy-mm-dd",
		// startDate: "0d",
		weekStart: 1,
		forceParse: true,
		orientation: "top"
	});

	$(document.body).on("click", ".reminder-remove", function(){
		$(this).parent().parent().next("input[type=hidden]").remove();
		$(this).parent().parent().remove();
	});

	$('#dissolver .word').on("click", function(){
		dissolve_element($(this));
	});

	$(".text_typer").keyup(function(event){
		var input = $(this).text().replace(/\xA0/g," ");

		var text = $(this).data("text").replace(/\xA0/g," ");
		var subText = text.substring(0, input.length);
		// alert(input + "/" + subText + "/");
		if (input == text){
			$(this).removeClass("fail");
			$(this).addClass("success");
		}
		else if (input != subText){
			$(this).removeClass("success");
			$(this).addClass("fail");
		}
		else{
			$(this).removeClass("fail");
			$(this).removeClass("success");
		}
	});

	$(".text_typer").keypress(function(event){
		if (event.key === "Backspace")
			return;
		var inputChar = String.fromCharCode((typeof event.which == "undefined") ? event.keyCode : event.which);
		if (event.ctrlKey || event.metaKey){
			if (inputChar == "h"){
				display_hint(event.shiftKey);
				return false;
			}
			return;
		}

		$(this).children().remove();
		var input = $(this).text().replace(/\xA0/g," ");
		var text = $(this).data("text").replace(/\xA0/g," ");
		if (input != text.substring(0, input.length))
			return false;

		var ignoreCase = $("#ignore-case").prop("checked");
		var ignorePunctuation = $("#ignore-punctuation").prop("checked");
		
		var textChar = text.charAt(input.length);
		if (inputChar != textChar){
			if (ignoreCase && inputChar.toUpperCase() == textChar){
				insertTextAtCursor(inputChar.toUpperCase());
				return false;
			}
			else if (ignoreCase && inputChar.toLowerCase() == textChar){
				insertTextAtCursor(inputChar.toLowerCase());
				return false;
			}
			else if (ignorePunctuation && !isAlphaNumeric(textChar) && textChar != ' '){
				if (inputChar == " ")
					inputChar = "\u00A0";
				insertTextAtCursor(textChar + inputChar);
				return false;
			}
		}
	});
})

function insertTextAtCursor(text) {
    var sel, range, textNode;
    if (window.getSelection) {
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();
            textNode = document.createTextNode(text);
            range.insertNode(textNode);

            // Move caret to the end of the newly inserted text node
            range.setStart(textNode, textNode.length);
            range.setEnd(textNode, textNode.length);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    } else if (document.selection && document.selection.createRange) {
        range = document.selection.createRange();
        range.pasteHTML(text);
    }
}

function isAlphaNumeric(str) {
  var code, i, len;

  for (i = 0, len = str.length; i < len; i++) {
    code = str.charCodeAt(i);
    if (!(code > 47 && code < 58) && // numeric (0-9)
        !(code > 64 && code < 91) && // upper alpha (A-Z)
        !(code > 96 && code < 123)) { // lower alpha (a-z)
      return false;
    }
  }
  return true;
};

function display_hint(fullWord){
	var elem = $(".text_typer");
	elem.get(0).focus();
	if (elem.children().length > 0)
		return;
	var counter = elem.text().length;
	var current = elem.data("text").charAt(counter);
	var hint = current;
	while (!isAlphaNumeric(current)){
		counter += 1;
		current = elem.data("text").charAt(counter);
		hint += current;
	}
	if (fullWord){
		while (isAlphaNumeric(current)){
			counter += 1;
			current = elem.data("text").charAt(counter);
			hint += current;
		}
	}
	hint.replace(/ /g, "\u00A0");
	elem.append("<span class='fade-out'>" + hint + "</span>");
	$( ".fade-out" ).fadeOut(1000, function() {
		$(this).children().remove();
		$(this).remove();
	});
}
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

function dissolve_all(){
	$('#dissolver').children('.word').each(function(){
		$(this).removeClass("dissolve-partial");
		$(this).addClass("dissolve");
	});
}

function dissolve_partial_all(){
	$('#dissolver').children('.word').each(function(){
		$(this).removeClass("dissolve");
		$(this).addClass("dissolve-partial");
	});
}

function appear_all(){
	$('#dissolver').children('.word').each(function(){
		$(this).removeClass("dissolve");
		$(this).removeClass("dissolve-partial");
	});
}

function dissolve_element(element)
{
	if (element.hasClass("dissolve-partial"))
	{
		element.addClass("dissolve")
		element.removeClass("dissolve-partial")
	}
	else if(element.hasClass("dissolve"))
	{
		element.removeClass("dissolve")
	}
	else
	{
		var className = element.children('.letter').length > 1 ? "dissolve-partial" : "dissolve";
		element.addClass(className);
	}
}

function add_fields(link, association, content) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $("#reminders").append(content.replace(regexp, new_id));  
}