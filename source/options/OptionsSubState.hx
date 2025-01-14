package options;

import Alphabet;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import OptionsMenu;

class OptionsSubState extends MusicBeatSubstate
{
	var textMenuItems:Array<String> = ['Controls', 'Perfernces', /*'System',*/ 'Misc', 'FPS', 'Exit'];

	var selector:FlxSprite;
	var curSelected:Int = 0;

	var grpOptionsTexts:FlxTypedGroup<Alphabet>;

	var textOptions:FlxText;

	public function new()
	{
		super();

		grpOptionsTexts = new FlxTypedGroup<Alphabet>();
		add(grpOptionsTexts);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Options State" + " | Press Enter to go this setting", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		for (i in 0...textMenuItems.length)
		{
			var optionText:Alphabet = new Alphabet(0, 50 + (i * 100), textMenuItems[i], true, false);
			optionText.ID = i;
			optionText.isMenuItem = true;
			optionText.targetY = i;
			grpOptionsTexts.add(optionText);
		}

		#if debug
		textMenuItems.insert(6, "Development");
		#end

	    textOptions = new FlxText(0, FlxG.height * 0.9 + 0, FlxG.width, "Edit your keybinds", 35);
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

		if (controls.DOWN_P)
			changeSelection(1);

		if(controls.BACK)
		{
			FlxG.state.closeSubState();
			FlxG.switchState(new MainMenuState());
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

		if (controls.ACCEPT)
		{
			switch (textMenuItems[curSelected])
			{
				case "Controls":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new options.ControlsSubState());
				case "Perfernces":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new options.PerferncesSubState());
				case "FPS":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new options.fps.FPSSubState());
				case "Misc":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new options.MiscSubState());
				case "Development":
					FlxG.state.closeSubState();
					FlxG.state.openSubState(new options.development.DevelopmentSubState());					
				case "Exit":
					FlxG.state.closeSubState();
					FlxG.switchState(new MainMenuState());
			}
		}
	}

	function changeSelection(change:Int = 0)
		{
			if (change != 0)
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
	
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = textMenuItems.length - 1;
			else if (curSelected >= textMenuItems.length)
				curSelected = 0;
	
			switch (textMenuItems[curSelected]){
				case "Controls":
					textOptions.text = "Edit your keybinds";
				case "Perfernces":
					textOptions.text = "Disable or Enable\nthe main setting";
				// case "System":
				// 	textOptions.text = "Disable or Enable\nthe system setting";
				case "FPS":
					textOptions.text = "Change FPS Cap";
				case "Misc":
					textOptions.text = "Disable or Enable\nthe misc setting";
				case "Exit":
					textOptions.text = "Return the game";
			}	
			var stuff:Int = 0;
	
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
