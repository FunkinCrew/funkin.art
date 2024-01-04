// Highlight keyframes in flash
// drag .jsfl script in
// will export the layer info of the first(?) element it finds?
// maybe someone can extend this to add more depth / functionality!
// see FramesJSFLParser.hx and CharSelectGF.hx for sample implementation

function splitArrayIntoChunks(array, chunkSize) {
    var result = [];
    for (var i = 0; i < array.length; i += chunkSize) {
        var chunk = array.slice(i, i + chunkSize);
        result.push(chunk);
    }
    return result;
}

fl.outputPanel.clear();

var timeline = fl.getDocumentDOM().getTimeline();
var daSelection = timeline.getSelectedFrames();
var splitArrays = splitArrayIntoChunks(daSelection, 3);

var uri = fl.browseForFolderURL("where to save files pick folder...");

for (var i = 0; i < splitArrays.length; i+=1)
{
    var curLayerInfo = splitArrays[i];
    var curLayerInd = curLayerInfo[0];
    var curLayer = fl.getDocumentDOM().getTimeline().layers[curLayerInd];

    var layerURI = uri + "/" + curLayer.name;

    FLfile.createFolder(layerURI);

    var fileData = "";


    var selectedFrames = curLayer.frames;
    var sliceLength = curLayerInfo[2] - curLayerInfo[1];
    selectedFrames =selectedFrames.slice(curLayerInfo[1],curLayerInfo[2]);


    for (var frameInd = curLayerInfo[1]; frameInd < curLayerInfo[2]; frameInd+=1)
    {
        var curFrame = curLayer.frames[frameInd];
        if (curFrame.isEmpty)
        {
            continue;
        }

        for (var elementInd = 0; elementInd < curFrame.elements.length; elementInd+=1)
        {

            var curElement = curFrame.elements[elementInd];
            fileData += curElement.left + " " + curElement.top + " " + curElement.colorAlphaPercent + "\n";
        }
    }

    FLfile.write(layerURI + "/" + curLayer.name + ".txt", fileData);

}



//fl.outputPanel.save(uri + "/nene.txt");
