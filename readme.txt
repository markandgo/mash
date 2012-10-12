===================
INTRODUCTION
===================

	Mash is an animation library for LOVE. It groups images together to create an animation object. The animation object is used to draw your animation. Simple right?

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
-- @param sequence     --> The associated sequence of images
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

===================
THE FORMAT
===================

	SEQUENCE
	===================

	A sequence is a table with a sequence of images (duh!). Here is an example:
	
sequence = 
{
	[1] = Image1,
	[2] = Image2,
}

	This sequence has two images. Images must be numbered from 1 and onward. Image1 and Image2 are the associated image type with each number.

	
	ANIMATION DATA
	===================
	
	Data about each animation must be build in a specific format. Here is an example:
	
animation = 
{
	[1] = 
	{
		img   = Image1,
		t     = delay,
		ox,oy = ox1,oy1,
	},
	[2] = 
	{
		img   = Image2,
		t     = delay2,
		ox,oy = ox2,oy2,
	},
},

	Here the animation data consists of two frames, 1 and 2. Frames are numbered from 1 and onward. Each frame must have the following attributes: Image, delay, ox,and oy. 
	
	The Image is your image data type for LOVE. The delay specifies how long the frame will play before finishing (in seconds). The ox and oy values are the x and y offsets, respectively, when drawn.
	
	ANIMATION OBJECT
	===================

	The animation object is what you use to draw an animation. It has the following format:
	
animObj = 
{
	status    = 'playing','paused', or 'stopped',
	
	frame     = frame number currently playing,
	
	t         = time elapsed in current frame,
	
	direction = direction of animation 1 or -1,
	
	animation = animation data table,
	
	mode      = 'loop','bounce', or 'once',
}