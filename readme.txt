===================
INTRODUCTION
===================

	Mash is an animation library for LOVE. It groups images together to create an animation object. The animation object is used to draw your animation. Simple right?
	
	Example can be found in the Downloads section.

===================
THE FUNCTIONS
===================

	CONSTRUCTORS
	===================

To use:

mash = require 'mash'

-- @param path        --> The path to the folder containg your images
-- @return sequences  --> table containing the sequences of images found in the folder
sequences = mash.getImages(path)

	Images must be formatted like "prefix-suffix.extension" for getImages to work. The prefix is the key in the sequences table. The prefix can be digits or a name, and the suffix is a number from 1 and onward. In other words, The prefix is the sequence name, and the suffix represents a number in the sequence.
	
sequences = 
{
	[prefix] = 
	{
		[suffix] = image
	},
	...
}

-- @param sequence --> A table containg a sequence of images
-- @param delay    --> The default delay for each frame
-- @param ox,oy    --> The optional x and y offsets for each frame
-- @return data    --> Animation data
data = mash.newData(sequence,delay,ox,oy)

or

-- @param sequence --> A table containg a sequence of images
-- @param callback --> user specified callback function. See below.
-- @return data    --> Animation data
data = mash.newData(sequence,callback)

	The callback function is used for setting custom delays and offsets for each frame. 
	
-- @param i            --> The frame number
-- @param sequence     --> The sequence table
-- @return delay,ox,oy --> The associated delay,ox,oy for frame i. Must return non-nil.
delay,ox,oy = callback(i,sequence)

-- @param data      --> The animation data table
-- @param mode      --> Optional animation mode: loop,bounce,once
-- @return animObj  --> animation object to be used for drawing
animObj = mash.new(data,mode)
	
	
	ANIMATION METHODS
	===================

-- Pause the animation
animObj:pause()

-- Resume the animation
animObj:resume()

-- Stop the animation and rewind to the beginning
animObj:stop()

-- @param frame     --> the frame number to jump to
-- @param direction --> Optional, specify which direction to continue when seeking: 1,-1
animObj:seek(frame,direction)

-- Update the animation. Put this in "love.update".
animObj:update(dt)

-- Draw the animation. Parameters are like "love.graphics.draw".
-- Note that the ox and oy parameters are summed with each frame's offsets.
animObj:draw(x, y, r, sx, sy, ox, oy, kx, ky)