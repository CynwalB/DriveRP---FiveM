

var listPos = {
    [1]:{container: "300", holders: "130"},
    [2]:{container: "400", holders: "230"},
    [3]:{container: "500", holders: "330"},
    [4]:{container: "570", holders:"420"}
}



$(function () {
    function display(bool, data) {
        if (bool) { 
            let placeHolders = ""
            let currentHeight = 570
            let currentIterator = 0

            data.placeHolders.forEach(element => {
                placeHolders = placeHolders + `<div id="placeholder"> <h2>${element.label}</h2> <input type="text" id="plc_${currentIterator}" placeholder="" class="input" required="true" name="need" neo="true" > </div>`
                currentIterator = currentIterator + 1 
            })
    
           
  
      
            $("#textContainer").html(
                `<h1>${data.label}</h1>` +
                `<div id="allPlaceHolders" data-aos="zoom-in"></div>` +
                `<button id="sumbit" style="outline: none;">${data.submitLabel}</button>`
            );
            $("#allPlaceHolders").html(placeHolders); 

            if (!listPos[currentIterator]) {
         
                $("#container").css("height", `${listPos[4].container}px`); 
                $("#allPlaceHolders").css("height", `${listPos[4].holders}px`); 
            } else {
                $("#container").css("height", `${listPos[currentIterator].container}px`); 
                $("#allPlaceHolders").css("height", `${listPos[currentIterator].holders}px`); 
            }
                
           
            
        
            
            $("#container").show();

        
            document.getElementById("sumbit").onmouseover = function() {mouseOver()};
            document.getElementById("sumbit").onmouseout = function() {mouseOut()};
        
        
            function mouseOver() { 
                
                if (checkForAccept(currentIterator)) {
                    document.getElementById("sumbit").style.borderBottom = "3px solid green";
                } else {
                    document.getElementById("sumbit").style.borderBottom = "3px solid red";
                }
               
            } 

            function mouseOut() {
                document.getElementById("sumbit").style.borderBottom = ""; 
            }

            $("#sumbit").click(function() {
                if (checkForAccept(currentIterator)) {

                    $.post(`http://${GetParentResourceName()}/sendInformation`, JSON.stringify(getInfoForAccept(currentIterator)));
                } 
            })  

        } else {
            $("#container").hide();
        }
    }
    display(false)
    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true, item.data) 
            } else {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post(`http://${GetParentResourceName()}/exit`, JSON.stringify({}));
            return
        }
    };

 
})

function checkForAccept(max) {
    let accepted = true
    for (let element = 0; element < max; element++) {
        if (!$(`#plc_${element}`).val()) {
            accepted = false
            break 
        }  
    } 
    return accepted
}

function getInfoForAccept(max) {
    var table = {}
    for (let element = 0; element < max; element++) {
        table[element] = $(`#plc_${element}`).val()
    }
    return table
}