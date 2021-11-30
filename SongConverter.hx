import haxe.Json;
import haxe.Log;
import haxe.macro.Compiler;
import sys.FileSystem;
import sys.io.File;

#if !interp
package art;

// needs this thing to be run by interp, just for me lol!
#end
// general use of this!!
// if run in INTERP MODE:
//		- art>haxe --main SongConverter --interp
//		- song to convert: ../assets/preload/data/
//		it will run through EVERY folder in there and convert the old songs to the new format!
// TODO make instructions for the C# script version!
class SongConverter
{
	public static var VERSION:String = '0.1.0';

	// TODO
	// Update engine shit, to accomodate single file
	static function main()
	{
		// trace(Compiler.get);
		trace(Compiler.getDefine('sysfsd'));

		Sys.stdout().writeString('Please type directory you want to convert: ');
		Sys.stdout().flush();
		final input = Sys.stdin().readLine();
		trace('Hello ${input}!');

		var songCount:Int = 0;

		for (fileThing in FileSystem.readDirectory('${input}/.'))
		{
			// trace(fileThing);
			// trace(FileSystem.isDirectory(${input} + "/" + fileThing));

			if (FileSystem.isDirectory(${input} + "/" + fileThing) && fileThing.toLowerCase() != 'smash')
			{
				songCount++;
				trace('Formatting $fileThing');
				formatSongs(fileThing, input);
			}
		}

		trace('CONVERTED $songCount SONGS!!');

		var timer:Int = 5;

		while (timer > 0)
		{
			Sys.stdout().writeString('CLOSING IN $timer SECONDS!');
			Sys.sleep(1);
			Sys.print("\r");
			timer -= 1;
		}
	}

	public static function formatSongs(songName:String, root:String)
	{
		var existsArray:Array<Bool> = [];
		var songFiles:Array<String> = [
			'$root/$songName/$songName-easy.json',
			'$root/$songName/$songName.json',
			'$root/$songName/$songName-hard.json'
		];

		existsArray.push(FileSystem.exists(songFiles[0]));
		existsArray.push(FileSystem.exists(songFiles[1]));
		existsArray.push(FileSystem.exists(songFiles[2]));

		// ALWAYS ASSUMES THAT 'songName.json' EXISTS AT LEAST!!!
		if (!existsArray[0])
			songFiles[0] = songFiles[1];
		if (!existsArray[2])
			songFiles[2] = songFiles[1];

		var fileNormal:Dynamic = cast Json.parse(File.getContent(songFiles[1]));
		var fileHard:Dynamic = cast Json.parse(File.getContent(songFiles[2]));
		var fileEasy:Dynamic = cast Json.parse(File.getContent(songFiles[0]));

		var daOgNotes:Dynamic = fileNormal.song.notes;
		var daOgSpeed:Float = fileNormal.song.speed;

		fileNormal.song.notes = [];
		fileNormal.song.speed = [];

		// fileEasy.song.notes = noteCleaner(fileEasy.song.notes);
		// daOgNotes = noteCleaner(daOgNotes);
		// fileHard.song.notes = noteCleaner(fileHard.song.notes);

		fileNormal.song.notes.push(fileEasy.song.notes);
		fileNormal.song.notes.push(daOgNotes);
		fileNormal.song.notes.push(fileHard.song.notes);

		fileNormal.song.speed.push(fileEasy.song.speed);
		fileNormal.song.speed.push(daOgSpeed);
		fileNormal.song.speed.push(fileHard.song.speed);
		fileNormal.song.hasDialogueFile = false;
		fileNormal.song.stageDefault = getStage(songName);

		// trace(fileNormal.song.speed);

		fileNormal.version = 'FNF SongConverter $VERSION';

		var daJson = Json.stringify(fileNormal, null, "\t");
		// trace(daJson);
		File.saveContent('$root/$songName/$songName-new.json', daJson);
	}

	static function noteCleaner(notes:Array<Dynamic>):Array<Dynamic>
	{
		var swagArray:Array<Dynamic> = [];
		for (i in notes)
		{
			if (i.sectionNotes.length > 0)
				swagArray.push(i);
		}

		return swagArray;
	}

	/**
	 * Quicky lil function just for me formatting the old songs hehehe	
	 */
	static function getStage(songName:String):String
	{
		switch (songName)
		{
			case 'spookeez' | 'monster' | 'south':
				return "spooky";
			case 'pico' | 'blammed' | 'philly':
				return 'philly';
			case "milf" | 'satin-panties' | 'high':
				return 'limo';
			case "cocoa" | 'eggnog':
				return 'mall';
			case 'winter-horrorland':
				return 'mallEvil';
			case 'senpai' | 'roses':
				return 'school';
			case 'thorns':
				return 'schoolEvil';
			case 'guns' | 'stress' | 'ugh':
				return 'tank';
			default:
				return 'stage';
		}
	}
}
