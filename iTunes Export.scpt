JsOsaDAS1.001.00bplist00�Vscript_'use strict';

// Ask where the export should be saved to.
var app = Application.currentApplication();
app.includeStandardAdditions = true;
var path = app.chooseFileName({
	withPrompt: "Save iTunes Library as:",
	defaultName: "iTunes Library Export.json",
});

// Get a reference to iTunes and turn on standard additions
var iTunes = Application("iTunes");

var playlists = iTunes.playlists();

// Determine how many tracks there are to be exported in total so that we can present
// progress to the user.
var totalTracks = 0;
playlists.forEach((playlist) => {
	totalTracks += playlist.tracks().length;
});

Progress.description = "Exporting Playlists...";
Progress.totalUnitCount = totalTracks;
Progress.completedUnitCount = 0;
Progress.additionalDescription = "";


// Loop over each of the playlists
var data = {};
data["playlists"] = playlists.map((p) => {
	Progress.additionalDescription = p.name();
	var playlist = p.properties();
	playlist.tracks = p.tracks().map((t) => {
		var track = t.properties();
		Progress.completedUnitCount += 1;
		return track;
	});
	return playlist;
});

var json = JSON.stringify(data);

var file = app.openForAccess(path, { writePermission: true });
app.setEof(file, { to: 0 });
app.write(json, { to: file, startingAt: app.getEof(file) });
app.closeAccess(file);
                              *jscr  ��ޭ