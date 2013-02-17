﻿import com.greensock.TweenLite;
import com.greensock.easing.Linear;

class skyui.widgets.activeeffects.ActiveEffectsGroup extends MovieClip
{
  /* PRIVATE VARIABLES */
  
	private var _effectsArray: Array


  /* PUBLIC VARIABLES */
  
  	// initObject
	public var index: Number;
	public var groupMoveDuration: Number;
	public var iconLocation: String;
	public var effectBaseSize: Number;
	public var effectSpacing: Number;
	public var effectFadeInDuration: Number;
	public var effectFadeOutDuration: Number;
	public var effectMoveDuration: Number;

	public var hAnchor: String;
	public var vAnchor: String;
	public var orientation: String;


  /* INITIALIZATION */
  
	public function ActiveEffectsGroup()
	{
		super();

		_effectsArray = new Array();

		var p = determinePosition(index);
		_x = p[0];
		_y = p[1];
	}


  /* PROPERTIES */
  
	public function get length(): Number
	{
		return _effectsArray.length;
	}
	

  /* PUBLIC FUNCTIONS */
  
	public function addEffect(a_effectData: Object): MovieClip
	{
		var effectIdx = _effectsArray.length;
		var initObject = {
			index: _effectsArray.length,
			effectData: a_effectData,
			iconLocation: iconLocation,
			effectBaseSize: effectBaseSize,
			effectSpacing: effectSpacing,
			effectFadeInDuration: effectFadeInDuration,
			effectFadeOutDuration: effectFadeOutDuration,
			effectMoveDuration: effectMoveDuration,
			hAnchor: hAnchor,
			vAnchor: vAnchor,
			orientation: orientation
		};
		
		var effectClip = attachMovie("ActiveEffect", a_effectData.id, getNextHighestDepth(), initObject);
		_effectsArray.push(effectClip);

		return effectClip;
	}

	public function updatePosition(a_newIndex: Number): Void
	{
		index = a_newIndex;

		var p = determinePosition(index);
		TweenLite.to(this, groupMoveDuration, {_x: p[0], _y: p[1], overwrite: 0, easing: Linear.easeNone});
	}

	public function onEffectRemoved(a_effectClip: MovieClip): Void
	{
		var removedEffectClip: MovieClip = a_effectClip;
		var effectIdx: Number = removedEffectClip.index;

		_effectsArray.splice(effectIdx, 1);
		removedEffectClip.removeMovieClip();

		if (_effectsArray.length > 0){
			var effectClip: MovieClip;

			for (var i: Number = effectIdx; i < _effectsArray.length; i++) {
				effectClip = _effectsArray[i];
				effectClip.updatePosition(i);
			}
		} else {
			// If the group had a background, for example, we'd call
			// this.remove()
			// which would fade out the group then, onComplete, call
			// _parent.onGroupRemoved(this);
			_parent.onGroupRemoved(this);
		}
	}


  /* PRIVATE FUNCTIONS */
  
	private function determinePosition(a_index: Number): Array
	{
		var newX: Number = 0;
		var newY: Number = 0;

		// Orientation is the orientation of the EffectsGroups
		if (orientation == "vertical") { // Orientation vertical means that the EffectsGroup acts as a column, so the next group needs to be added either to the left, or right
			if (hAnchor == "right") { // Widget is anchored horizontally to the right of the stage, so need to add next EffectsGroup to the left
				newX = -(effectSpacing + index * (effectBaseSize + effectSpacing));
			} else {
				newX = +(effectSpacing + index * (effectBaseSize + effectSpacing));
			}
		} else { // Orientation horizontal means that the EffectsGroup acts as a row, so the next group needs to be added either above, or below
			if (vAnchor == "bottom") { // Widget is anchored vertically to the bottom of the stage, so need to add next EffectsGroup above
				newY = -(effectSpacing + index * (effectBaseSize + effectSpacing));
			} else {
				newY = +(effectSpacing + index * (effectBaseSize + effectSpacing));
			}

		}

		return [newX, newY];
	}

  	// Not needed, see onEffectRemoved();
  	/*
  	private function remove(): Void
  	{
		TweenLite.to(this, effectFadeOutDuration, {_alpha: 0, onCompleteScope: _parent, onComplete: _parent.onGroupRemoved, onCompleteParams: [this], overwrite: 2, easing: Linear.easeNone});
  	}
  	*/
}


