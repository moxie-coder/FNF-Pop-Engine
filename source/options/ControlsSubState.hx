package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import Controls.Control;
import MusicBeatState;
import Controls;
import flixel.FlxSubState;
import OptionsMenu;
import flixel.util.FlxSave;

class ControlsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Left', 'Down', 'Up', 'Right', 'Reset', 'Exit'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;

	var BG:FlxSprite;

	var keyBind:FlxText;

	var label:FlxText;

	var textOptions:FlxText;

	public static var MUSICBEATSTATE:MusicBeatState;

	var save = new FlxSave();

	public function new()
	{
		super();

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Controls State", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		save.bind("Options");
		try{
			if(save.data.options == null)
				save.data.options = new Array<String>();
				save.data.options[0] = "";
		}catch(e){
			trace("not work");
		}
		
		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, 50 + (i * 100), textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);
		}

		if (save.data.options.contains("Enable CHEAT Key"))
			textMenuItems.insert(7, "Cheat");
		else
			textMenuItems.remove("Cheat");
		
		BG = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 4), Std.int(FlxG.height / 2) + 500, 0xFF000000);
		BG.x = FlxG.width - BG.width;
		BG.alpha = 0.25;
		add(BG);

		keyBind = new FlxText(/*healthBarBG.x + healthBarBG.width - 130 */ 1100, 200, CoolUtil.coolTextFileString(Paths.txt('options/keybinds/left')), 20);
		keyBind.setFormat(Paths.font("vcr.ttf"), 70, FlxColor.WHITE, RIGHT);
		keyBind.scrollFactor.set();
		add(keyBind);

		label = new FlxText(/*healthBarBG.x + healthBarBG.width - 130 */ 965, 100, "Keybind: ", 30);
		label.setFormat(Paths.font("vcr.ttf"), 70, FlxColor.WHITE, RIGHT);
		label.scrollFactor.set();
		add(label);

		textOptions = new FlxText(0, FlxG.height * 0.9 + 0, FlxG.width, "", 35);
		textOptions.scrollFactor.set();
		textOptions.setFormat(Paths.ttffont("phantommuffin"), 35, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(textOptions);	

		changeSelection();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);
			//curSelected -= 1;

		if (controls.DOWN_P)
			changeSelection(1);
			//curSelected += 1;

		if(controls.BACK){
			FlxG.state.openSubState(new OptionsSubState());
		}	
		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;

		if (curSelected >= textMenuItems.length)
			curSelected = 0;

		grpOptionsTexts.forEach(function(txt:Alphabet)
		{
			txt.color = FlxColor.WHITE;

			if (txt.ID == curSelected)
				txt.color = FlxColor.YELLOW;
			else
				txt.color = FlxColor.WHITE;
		});

		if(textMenuItems[curSelected] != "Exit"){
			keyBind.text = CoolUtil.coolTextFileString(Paths.txt('options/keybinds/' + textMenuItems[curSelected].toLowerCase()));
		}else{
			keyBind.text = "";
		}

		if (MUSICBEATSTATE.controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				case "Exit":
					FlxG.state.openSubState(new OptionsSubState());
			}
		}
		
		if(FlxG.keys.justPressed.ANY && !controls.ACCEPT && !controls.RIGHT && !controls.LEFT && !controls.UP && !controls.DOWN && !controls.BACK && !controls.PAUSE){
			switch (textMenuItems[curSelected]){
				case "Left":
					sys.io.File.saveContent(Paths.txt('options/keybinds/left'), FlxG.keys.getIsDown()[0].ID.toString());
					controls.setKeyboardScheme(Solo);
				case "Down":
					sys.io.File.saveContent(Paths.txt('options/keybinds/down'), FlxG.keys.getIsDown()[0].ID.toString());
					controls.setKeyboardScheme(Solo);
				case "Up":
					sys.io.File.saveContent(Paths.txt('options/keybinds/up'), FlxG.keys.getIsDown()[0].ID.toString());
					controls.setKeyboardScheme(Solo);
				case "Right":
					sys.io.File.saveContent(Paths.txt('options/keybinds/right'), FlxG.keys.getIsDown()[0].ID.toString());
					controls.setKeyboardScheme(Solo);
				case "Reset":
					sys.io.File.saveContent(Paths.txt('options/keybinds/reset'), FlxG.keys.getIsDown()[0].ID.toString());
					controls.setKeyboardScheme(Solo);
				case "Cheat":
					sys.io.File.saveContent(Paths.txt('options/keybinds/cheat'), FlxG.keys.getIsDown()[0].ID.toString());
					controls.setKeyboardScheme(Solo);
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		if (change != 0)
			FlxG.sound.play(Paths.sound('scrollMenu', 'preload'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = textMenuItems.length - 1;
		else if (curSelected >= textMenuItems.length)
			curSelected = 0;

		var stuff:Int = 0;

		switch(textMenuItems[curSelected])
		{
			case "Left":
				textOptions.text = "Change Left Key";

			case "Down":
				textOptions.text = "Change Down Key";

			case "Up":
				textOptions.text = "Change Up Key";

			case "Right":
				textOptions.text = "Change Right Key";

			case "Reset":
				textOptions.text = "Change Reset Key";

			case "Exit":
				textOptions.text = "Return Options Menu";

			case "Cheat":
				textOptions.text = "Change Cheat Key";
		}

		for (item in grpOptionsTexts.members)
		{
			item.targetY = stuff - curSelected;
			stuff ++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}

	}
}