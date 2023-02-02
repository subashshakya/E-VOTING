// JavaScript source code




var currentFormat = Fingerprint.SampleFormat.Intermediate;
//var currentFormat = Fingerprint.SampleFormat.Raw;
var test = null;
var fingerdata = [];
var data;
var state = document.getElementById('content-capture');
//Events
var FingerprintSdkTest = (function () {
    function FingerprintSdkTest() {
        var _instance = this;
        this.operationToRestart = null;
        this.acquisitionStarted = false;
        this.sdk = new Fingerprint.WebApi;
        this.sdk.onDeviceConnected = function (e) {
            // Detects if the deveice is connected for which acquisition started
            showMessage("Scan your finger");
        };
        this.sdk.onDeviceDisconnected = function (e) {
            // Detects if device gets disconnected - provides deviceUid of disconnected device
            showMessage("Device disconnected");
        };
        this.sdk.onCommunicationFailed = function (e) {
            // Detects if there is a failure in communicating with U.R.U web SDK
            showMessage("Communinication Failed")
        };
        this.sdk.onSamplesAcquired = function (s) {
            // Sample acquired event triggers this function
            var samples = JSON.parse(s.samples);
            var sampleData = Fingerprint.b64UrlTo64(samples[0].Data);
            data = sampleAcquired(s);
            if (fingerdata.length <= 2) {
                fingerdata.push(data);
            }
            else {
                fingerdata.push(data);
                onStop();
                SaveData(fingerdata);
                
            }

        };
        this.sdk.onQualityReported = function (e) {
            // Quality of sample aquired - Function triggered on every sample acquired
            document.getElementById("qualityInputBox").value = Fingerprint.QualityCode[(e.quality)];
        }

    }

    FingerprintSdkTest.prototype.startCapture = function () {
        if (this.acquisitionStarted) // Monitoring if already started capturing
            return;
        var _instance = this;
        showMessage("");
        this.operationToRestart = this.startCapture;
        this.sdk.startAcquisition(currentFormat, "D354D438-3EB4-EE4B-BCAD-955E2500CE6D").then(function () {
            _instance.acquisitionStarted = true;

            //Disabling start once started
            //disableEnableStartStop();

        }, function (error) {
            showMessage(error.message);
        });
    };
    FingerprintSdkTest.prototype.stopCapture = function () {
        if (!this.acquisitionStarted) //Monitor if already stopped capturing
            return;
        var _instance = this;
        showMessage("");
        this.sdk.stopAcquisition().then(function () {
            _instance.acquisitionStarted = false;

            //Disabling stop once stoped
            //disableEnableStartStop();

        }, function (error) {
            showMessage(error.message);
        });
    };

    FingerprintSdkTest.prototype.getInfo = function () {
        var _instance = this;
        return this.sdk.enumerateDevices();
    };

    FingerprintSdkTest.prototype.getDeviceInfoWithID = function (uid) {
        var _instance = this;
        return this.sdk.getDeviceInfo(uid);
    };


    return FingerprintSdkTest;
})();
function showMessage(message) {
    var _instance = this;
    //var statusWindow = document.getElementById("status");
    x = state.querySelectorAll("#status");
    if (x.length != 0) {
        x[0].innerHTML = message;
    }
}

function onStart() {
    console.log("Start Called")
    fingerdata = [];
    currentFormat = Fingerprint.SampleFormat.Intermediate;
    //currentFormat = Fingerprint.SampleFormat.Raw;
    if (currentFormat == "") {
        alert("Please select a format.")
    } else {
        console.log("Started!")
        test.startCapture();
    }
}
var sample = "";

window.onload = function () {
    test = new FingerprintSdkTest();
    var count = 0;
    /*while (count != 4) {*/
        onStart();
        //count = count + 1;
    //}

    // onStop();
};

function onStop() {
    console.log("Stopped!")
    test.stopCapture();
}

function sampleAcquired(s) {
    if (currentFormat == Fingerprint.SampleFormat.Intermediate) {
        //// If sample acquired format is Intermediate- perform following call on object recieved 
        //// Get samples from the object - get 0th element of samples and then get Data from it.
       // // It returns Base64 encoded feature set
        localStorage.setItem("intermediate", "");
        var samples = JSON.parse(s.samples);
        var sampleData = Fingerprint.b64UrlTo64(samples[0].Data);
        localStorage.setItem("intermediate", sampleData);
        //var FMDs = [];
        sample = document.getElementById('imagediv').innerHTML = '<div id="animateText" style="display:none">Intermediate Sample Acquired <br>' + Date() + '</div>';
        setTimeout('delayAnimate("animateText","table-cell")', 100);
        //SaveData(sampleData);
        return sampleData;
    }
    
    else {
        alert("Format Error");
        //disableEnableExport(true);
    }
}


function delayAnimate(id, visibility) {
    document.getElementById(id).style.display = visibility;
}




/////// Exporting

function downloadURI(uri, name, dataURIType) {
    if (IeVersionInfo() > 0) {
        //alert("This is IE " + IeVersionInfo());
        var blob = dataURItoBlob(uri, dataURIType);
        window.navigator.msSaveOrOpenBlob(blob, name);

    } else {
        //alert("This is not IE.");
        var save = document.createElement('a');
        save.href = uri;
        save.download = name;
        var event = document.createEvent("MouseEvents");
        event.initMouseEvent(
            "click", true, false, window, 0, 0, 0, 0, 0
            , false, false, false, false, 0, null
        );
        save.dispatchEvent(event);
    }
}

dataURItoBlob = function (dataURI, dataURIType) {
    var binary = atob(dataURI.split(',')[1]);
    var array = [];
    for (var i = 0; i < binary.length; i++) {
        array.push(binary.charCodeAt(i));
    }
    return new Blob([new Uint8Array(array)], { type: dataURIType });
}
function IeVersionInfo() {
    var sAgent = window.navigator.userAgent;
    var IEVersion = sAgent.indexOf("MSIE");

    // If IE, return version number.
    if (IEVersion > 0)
        return parseInt(sAgent.substring(IEVersion + 5, sAgent.indexOf(".", IEVersion)));

    // If IE 11 then look for Updated user agent string.
    else if (!!navigator.userAgent.match(/Trident\/7\./))
        return 11;

    // Quick and dirty test for Microsoft Edge
    else if (document.documentMode || /Edge/.test(navigator.userAgent))
        return 12;

    else
        return 0; //If not IE return 0
}

function SaveData(sampledata) {
    //var url = "/Home/Privacy?data=" + sampledata;
    console.log(sampledata);
    $.ajax({
        type: "post",
        url: "/Home/Privacy",
        data: JSON.stringify(sampledata),
        contentType:"application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            if (result == "Saved") {
                alert("Saved");
            }
            else {
                alert("Error");
            }
        }
    })
}