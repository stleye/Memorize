# Memorize

### Layout

#### How is the space on-screen apportioned to the Views?

1 - Container Views "offer" space to the Views inside them
2 - Views then choose what size they want to be
3 - Container Views then position the Views inside of them
4 - (and based on that, Container Views choose their own size as per #2 above)

#### HStack and VStack
Stacks divide up the space that is offered to them and then offer that to he views inside.
It offers space to its "least flexible" (with respect to the sizing) subviews first

Example of "inflexible" View: `Image` (it wants to be a fixed size)
Another example (slightly more flexible): `Text` (always wants to size to exactly fit its text)
Example of a very flexible View: `RoundedRectangle` (always uses any space offered)

After an offered View(s) takes what it wants, its size is removed from the space available.
Then the stack moves on to the next "least flexible" Views.
Very flexible views (i.e. those that will take all offered space) will share evenly (mostly).
Rinse and repeat

After the Views inside the stack choose their own sizes, the stack sizes itself to fit them.
If any of the Views in the stack are "very flexible", then the stack will also be "very flexible".

There are a couple of really valuable Views for layout that are commonly put in stacks...
`Spacer(minLength: CGFloat)`
Always takes all the space offered to it.
Draws nothing.
The minLength defaults to the most likely spacing you'd want on a given platform.

`Divider()`

Draws a dividing line cross-wise to the way the stack is laying out.
For example, in an HStack, divider draws a vertical line
Takes the minimum space needed to fit the line in the direction the stack is going

Stack's choice of who to offer space to next can be overriden with .layoutPriority(Double).
In other words, `layoutPriority` trumps "least flexible".

```swift
HStack {
    Text("Important").layoutPriority(100) //any floating point number is okay
    Image(systemName: "arrow.up") //the default layout priority is 0
    Text("Unimportant")
}
```

The Important Text above will get the space it wants first
Then the Image would get its space (since it's less flexible than the Unimportant Text).
Finally, Unimportant would have to try to fit itself into any remainding space.
If a Text doesn't get enough space, it will elide (e.g. "Swift is..." instead of "Swift is great!")

Another crucial aspect of the way stacks lay out the Views they contain is alignment.
When a VStack lays Views out in a column, what if the Views are not all the same width?
Does it "left align" them? Or center them? Or what?

This is specified via an argument to the stack...
`VStack(alignment: .leading) { ... }`

Text baselines can also be used to align (e.g `HStack(alignment: .firstTextBaseline) { }`)

You can even define your on "things to line up" alignment guides.

#### LazyHStack and LazyVStack

These "lazy" versions of the stack don't build any of their Views that are not visible.
They also size themselves to fit their Views
So they don't take up all the space offered to them even if they have flexible views inside.
You'd use these when you have a stack that is in a ScrollView.

#### ScrollView

ScrollView takes all the space offered to it.
The views inside it are sized to fit along the axis your scrolling on.

#### LazyHGrid and LazyVGrid

Check the code in this repo

#### List and Form and OutlineGroup
These are sort of like "really smart VStacks"

#### ZStack

ZStacks sizes itself to fit its children
If even one of its children is fully flexible size, then the ZStack will be too

- .background modifier
`Text("Hello").background(Rectangle().foregroundColor(.red))`
This is similar to making ZStack of this Text and Rectangle (with the Text in front).
However there's a big difference in layout between this and using a ZStack to stack them.
In this case, the resultant View will be `sized to the Text` (the Rectangle is not involved).
In other words, the Text solely determines the layout of this "mini-ZStack of two things".

- .overlay modifier
Same layout rules as .background, but stacked the other way around.
`Circle().overlay(Text("Hello"), alignment: .center)`
This will be `sized to the Circle` (i.e. it will be fully-flexible sized).
The Text ill be stacked on top of the Circle (with the specified alignment inside the Circle).

##### Modifiers

- Remember that View modifier functions (like .padding) themselves return a View.
That View, conceptually anyway, "contains" the View it's modifying.
- Many of them just pass the size offered to them along (like .font or .foregroundColor).
But it is possible for a modifier to be involved in the layout process itself.
For example the View returned by .padding(10) will offer the View that it is modifying a space that is the same size as it was offered, but reduced by 10 points on each side.
The View returned by .padding(10) would then choose a size for itself which is 10 points larger on all sides than the View it is modifying ended up choosing.
Another example is .aspectRatio.
The View returned by the .aspectRatio modifier takes the space offered to it and picks a size for itself that is either smaller (.fit) to respect the ratio or bigger (.fill) to use all the offered space (and more, potentially) and respect the ratio.
(yes, a View is allowed to choose a size for itself that is larger than the space it was offered!)
.aspectRatio then offers the space it chose to the View it is modifying (as its "container").

###### Example 

```swift
HStack { //aside: the default alignment here is .center (not .top, for example)
    ForEach(viewModel.cards) { card in 
        CardView(card: card).aspectRatio(2/3, contentMode: .fit)
    }
}
.foregroundColor(.orange)
.padding(10)
```
The first View to be offered space here will be the View made by .padding(10)
Which will offer what it was offered minus 10 on all sides to the View from .foregroundColor
Which will in turn offer all of that space to the HStack
Which will then divide its space equally among the .aspectRatio Views in the ForEach
Each .aspectRatio View will set its width to be its share of the HStack's width and pick a height for itself that respects the requested 2/3 aspect ratio.
Or it might be forced to take all of the offered height and choose its width using the ratio.
(Whichever fits.)
The .aspectRatio then offers all of its chosen size to its CardView, which will use it all.

Once all this happen, the size of this whole View (i.e. the one returned from .padding(10)) chooses for itself will be...
The result of the HStack sizing itself to fit those .aspectRatio Views + 10 points on all sides.

###### Views that take all the space offered to them
Most Views simply sizes themselves to take up all the space offered to them.
For example, Shapes usually draw themselves to fit (like RoundedRectangle).

Custom Views (like CardView) should do this too whenever sensible.
But they really should adapt themselves to any space offered to look as good as possible.
For example, CardView would want to pick a font size that makes its emoji fill the space.

#### GeometryReader

You wrap this `GeometryReader` View around what would normally appear in your View's body...
```swift
var body: View {
    GeometryReader { geometry in
        ...
    }
}
```

GeometryReader itself (it's just a View) `always accepts all the space offered to it`

#### Safe Area
Generally, when a View is offered space, that space does not include "safe areas".
The most obvious "safe area" is the notch on an iPhone X.
Surrounding Views might also introduce "safe areas" that Views inside shouldn't draw in.

But it is possible to ignore this and draw in those areas anyway on specified edges...
`ZStack { ... }.edgesIgnoringSafeArea([.top])` //draw in "safe area" on top edge

#### @ViewBuilder

Based on a general technology added to Swift to support "list-oriented syntax".
It's a simple mechanism for supporting a more conventional syntaxt for `list of Views`
Developers can apply it to any of their functions that return something that conforms to View.
If applied, the function still `returns something that conforms to View`
But it will do so by interpreting the contents as a `list of Views and combines them into one.`

That one View that it combines it into might be a TupleView (for two or more Views).
Or it could be a _ConditionalContent View (when there's an if-else in there).
Or it could even be EmptyView (if there's nothing at all in there; weird, but allowed).
And it can be any combination of the above (if's inside other if's, etc).

Note that some of this is not yet fully public API (like _ConditionalContent).
But `we don't actually care what View it creates` for us when it combines the Views in the list.
It's always just `some View`as far as we're concerned.

Any func or read-only computed var can be marked with `@ViewBuilder`.
If so marked, the contents of that func or var will be interpreted as a list of Views.
For example, if we wanted to factor out the Views we use to make the front of a Card...

```swift
@ViewBuilder
func front(of card: Card) -> some View {
    let shape = RoundedRectangle(cornerRadius: 20)
    shape
    shape.stroke()
    Text(card.content)
}
```
And it would be legal to put simple if-else's to control which Views are included in the list.
(But this is just the front of our card, so we don't need any ifs.)
The above would return a `TupleView<RoundedRectangle, RoundedRectangle, Text>`

You can also use `@ViewBuilder` to mark a parameter of a function or an init.
That argument's type must be "a function that returns a View".
ZStack, HStack, VStack, ForEach, LazyVGrid, etc. all do this (their content: parameter).

#### Shape

Shape is a protocol that inherits from View.
In other words, all Shapes are also Views.
Examples of Shapes already om SwiftUI: RoundedRectangle, Circle, Capsule, etc

By default, Shapes draw themselves by filling with the current foreground color.
But they can be changed with .stroke() and .fill().
They return a View that draws the Shape in the specified way (by stroking or filling)

The arguments to stroke and fill are pretty interesting.
`func fill<S>(_ whatToFillWith: S) -> some View where S: ShapeStyle`
This is a generic function (similar to, but different than, a generic type).
`S` is a don't care (but since there's a where, it becomes a "care a little bit")
`S` can be anything that implements the `ShapeStyle` protocol
The `ShapeStyle` protocol turns a `Shape` into a `View` by apply some styling to it.
Examples of such things: Color, ImagePaint, AngularGradient, LinearGradient.

But what if we want to create our own Shape?

The Shape protocol (by extension) implements View's body var for us.
But it introduces its own func that we are required to implement...
```Swift
func path(in rect: CGRect) -> Path {
    return a Path
}
```
In here we will create and return a Path that draws anything we want.
`Path` has a ton of functions to support drawing (check out its documentation).
It can add lines, arcs, bezier curves, etc. together to make a shape.

#### ViewModifier

All those little functions that modified our Views (like aspectRatio and padding)?
They are (likely) turning right around and calling a function in View called `modifier`

e.g. .aspectRatio(2/3) is likely something like `.modifier(AspectModifier(2/3))`
`AspectModifier` can be anything that conforms to `ViewModifier` protocol...

The `ViewModifier` protocol has one function in it.
This function's only job is to create a new View based on the thing passed to it.
Conceptually, this protocol is sort of like this...

```Swift
protocol ViewModifier {
    typealias Content //the type of the View passed to body(content:)
    func body(content: Content) -> some View {
        return some View that almost certainly contains the View content
    }
}
```

When we call `.modifier` on `a View`, the `Content` passed to this function is `that View.`

ViewModifier code looks a lot like View code (`func body(content:)` instead of `var body`).
That's because `ViewModifier`s are Views.
And writing the code for one is almost identical.

There is a special ViewModifier, `GeometryEffects`, for building geometry modifiers.

Let's say we wanted to create a modifier that would "card-ify" another View.
In other words, it would take that View and put it on a card like in the Memorize game.
It would work with any View whatsoever (not just our Text("X")).
What would such a modifier look like?

##### Cardify ViewModifier

```Swift
Text("X").modifier(Cardify(isFaceUp: true)) //eventually .cardify(isFaceUp: true)
struct Cardify: ViewModifier {
    var isFaceUp: Bool
    func body(content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10).fill(Color.white)
                RoundedRectangle(cornerRadius: 10).stroke()
                content
            } else {
                RoundedRectangle(cornerRadius: 10)
            }
        }
    }
}
```

How do we get from ...
`Text("X").modifier(Cardify(isFaceUp: true))`
to...
`Text("X").cardify(isFaceUp: true)`

Easy...

```Swift
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        return self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
```

#### Animation

One way to do animation is by animating a `Shape`
The other way to do animation is to animate Views via their ViewModifiers.

##### Important takeaways about Animation
- Only changes can be animated. Changes to what?
ViewModifier arguments
Shapes
The "existence" (or not) of a View in the UI

- Animation is showing the user changes that have already happened (i.e. the recent past)
- ViewModifiers are the primary "change agents" in the UI
A change to a ViewModifier's arguments has to happen after the View is initially put in the UI.
In other words, only changes in a ViewModifier's arguments since it joined the UI are animated.
Not all ViewModifier arguments are animatable (e.g. font's are not), but most are.
When a View arrives or departs, the entire thing is animated as a unit.
A view coming on-screen is only animated if it's joining a container that is already in the UI.
A view going off-screen is only animated if it's leaving a container that is staying in the UI.
ForEach and if-else in ViewBuilders are common ways to make Views come and go.

##### How do we make an animation "go"?

Three ways
- Implicitly (automatically), by using the view modifier `.animation(Animation)`
- Explicitly, by wrapping `withAnimation(Animation) { }` around code that might change things.
- By making Views be included or excluded from the UI.

All of the above only cause animations to "go" if the View is already part of the UI (or if the View is joining a container that is already part of the UI)

###### Implicit Animation
"Automatic animation" Essentially marks a View so that ...
All ViewModifier arguments that precede the `animation` modifier will always be animated.
The changes are animated with the duration and "curve" we specify 
We simply add `.animation(Animation)` view modifier to the View we want to auto-animate.
```Swift
Text("X")
    .opacity(scary ? 1 : 0)
    .rotationEffect(Angle.degrees(upsideDown ? 180 : 0))
    .animation(Animation.easeInOut)
```
Now whenever `scary` or `upsideDown` changes, the opacity/rotation will be animated.
All changes to arguments are animatable view modifiers preceding `.animation` are animated.
Without `.animation()`, the changes to opacity/rotation would appear instantly on screen.

`Warning!` The .animation modifier does not work how we might thing on a container.
A container just propagates the .animation modifier to all the Views it contains.
In other words, .animation does not work like .padding, it works more like .font.

The argument to .animation() is an `Animation` struct.
It lets us control things about an animation ...
Its `duration`.
Whether to `delay` a little bit before starting it.
Whether it should `repeat` (a certain number of times or even `repeatForever`).
Its "curve"...

###### Animation Curve
The kind of animation controls the rate at which the animation "plays out" (it's "curve")...
`.linear` This means exactly what it sounds like: consistent rate throughout.
`.easeInOut` Starts out the animation slowly, picks up speed, then slows at the end.
`.spring` Provides "soft landing" (a "bounce") for the end of the animation.

###### Implicit vs. Explicit Animation
These "automatic" implicit animations are usually not the primary source of animation behavior.
They are mostly used on "leaf" (i.e. non-container, aka "Lego brick") Views.
Or, more generally, on Views that are typically working independently of other Views.

A likely more common cause of animations is a change in our Model.
Or, more generally, changes in response to some user action.
For these changes, we want a whole bunch of Views to animate together.
For that, we use Explicit Animation...

###### Explicit Animation

Explicit Animations create an animation transaction during which...
All eligible changes made as a result of executing a block of code will be animated together.

We supply the Animation (duration, curve, etc) to use and the block of code.
```Swift
withAnimation(.linear(duration: 2)) {
    // do something that will cause ViewModifier/Shape arguments to change somewhere
}
```
Explicit Animations are almost always wrapped around calls to `ViewModel Intent functions`.
But they are also wrapped around things that only change the UI like "entering editing mode"
It's fairy rare for code that handles a user gesture to not be wrapped in a withAnimation.

`Explicit animations do not override an implicit animation.`

###### Transitions

Transitions specify how to animate the arrival/departure of Views
Only works for Views that are inside Containers That are Already On-Screen

Under the covers, a transition os nothing more than a pair of ViewModifiers.
One of the modifiers is the "before" modification of the View that's on the move.
The other modifier is the "after" modification of the View that's on the move.
This a transition is just a version of a "changes in arguments to ViewModifiers" animation.

An asymmetric transition has 2 pairs of ViewModifiers.
One pair for when the View appears (insertion)
And another pair for when the View disappears (removal)
Example: a View fades in when it appears, but then flies across the creen when it disappears.
Mostly we use "pre-canned" transitions (opacity, scaling, moving across the screen).
The are static vars/funcs on the `AnyTransition` struct.

All the transitions API is "type erased"
We use the struct `AnyTransition` which erases type info for the underlying ViewModifiers
This makes it a lot easier to work with transitions

For example, here are some of the built-in transitions...
`AnyTransition.opacity` (uses .opacity modifier to fade the View in and out)
`AnyTransition.scale` (uses .frame modifier to expand/shrink the View as it comes and goes)
`AnyTransition.offset(CGSize)` (use .offset modifier to move the View as it comes and goes)
`AnyTransition.modifier(active:identity:)` (you provide the two ViewModifiers to use)

How do we specify which kind of transition to use when a View arrives/departs?

Using `.transition()`. Example using two built-in transitions, `.scale` and `.identity`...

```Swift
ZStack {
    if isFaceUp {
        RoundedRectangle(cornerRadius: 10).stroke()
        Text("X").transition(AnyTransition.scale)
    } else {
        RoundedRectangle(cornerRadius: 10).transition(AnyTransition.identity)
    }
}
```

If isFaceUp changed from false to true...
(and ZStack was already on screen and we were explicitly animating)
... the back would disappear instantly, Text would grow from nothing, front RR would fade in.

Unlike .animation(), .transition() does not get redistributed to a container's content Views.
So putting .transition() on the ZStack above only works if the entire ZStack came/went.
(Group and ForEach do distribute .transition() to their content Views, however.)

`.transition()` is just specifying what the ViewModifiers are.
It doesn't cause any animation to occur.
In other words, think of the word transition as a noun here, not a verb
We are declaring what transition to use, not causing the transition to occur.

Setting Animation Details for a Transition

We can set an animation (curve/duration/etc). to use for a transition.
AnyTransition structs have a `.animation(Animation)` of their own we can call.
This sets the Animation parameters to use to animate the transition.
e.g. `.transition(AnyTransition.opacity.animation(.linear(duration: 20)))`

###### Matched Geometry Effect
Sometimes we want a View to move from one place on screen to another.
(And possibly resize along the way.)
If the View is moving to a new place in its same container, this is no problem.
"Moving" like this is just animating `.position` ViewModifier's arguments.
(`.position` is what HStack, LazyVGrid, etc, use to position the Views inside them.)
This kind of things happen automatically when we explicitly animate.

But what if the View is "moving" from one container to a different container?
This is not really possible.
Instead, we need a View in the "source" position and a different one in the "destination" position.
And then we must "match" their geometries up as one leaves the UI and the other arrives.
So this is similar to .transition in that it is animating Views coming and going in the UI.
It's just that it's particular to the case where a pair of Views arrivals/departures are synced.

A great example of this would be "dealing cards off of a deck".
The "deck" might well be its own View off to the side.
When a card is "dealt" from the deck, it needs to fly from there to the game.
But the deck and game's main View are not in the same LazyVGrid or anything.
How do we handle this?

We mark both Views using this ViewModifier...
`.matchedGeometryEffect(id: Id, in: Namespace)` // ID type is a "don't care": Hashable
Declare the Namespace as a private var in our View like this...
`@Namespace private var myNamespace`

Now we write our code so that only one of the two is ever included in the UI at the same time.
We can do this with if-else in a ViewBuilder or maybe via ForEach.
Now, when one of the pair leaves and the other arrives at the same time, their size and position will be synced up and animated.

`.onAppear`
Remember that animations work only on Views that are in Containers that are already on-screen
How can we kick off an animation as soon as a View's Container arrives On-Screen?

View has a nice function called `.onAppear { }`
It executes a closure any time a View appears on screen (there's also .onDisappear { }).

Use `.onAppear { }` on your container view to cause a change (usually in Model/ViewModel)
that results in the appearance/animation of the View you want to be animated.
Since, by definition, your container is on-screen when its own `.onAppear { }` is happening, it is a CTAAOS, so any animations for its children that are appearing can fire.
Of course, you'd need to use withAnimation inside `.onAppear { }`.

###### Shape and ViewModifier Animation
All actual animation happens in Shapes and ViewModifiers.
(Even transitions and matchedGeometryEffects are just "paired ViewModifiers".)
So how do they actually do their animation?
(along whatever the "curve" the animation uses)

A Shape or ViewModifier lets the animation system know what information it wants piece-ified.
(e.g. our Pie Shape is going to want to divide the Angles of the pie up into pieces.)

During animation, the system tells the Shape/ViewModifier the current piece it should show.
The Shape/ViewModifier makes sure its body draws appropiately at any "piece" value.

The communication with the animation system happens (both ways) with a single var.
This var is the only thing in the Animatable protocol.
Shapes and ViewModifiers that want to be animatable must implement this protocol.

`var animatableData: Type`

`Type` is a "care a little bit"
Type has to implement the protocol `VectorArithmetic`
That's because it has to be able to be broken up into little pieces on an animation curve.

`Type` is very often a floating point number (Float, Double, CGFloat)
But there's another struct that implements `VectorArithmetic` called `AnimatablePair`
`AnimatablePair` combines two `VectorArithmetics` into one `VectorArithmetic`
Of course we can have `AnimatablePairs` of `AnimatablePair` so we can animate all we want

Because it's communicating both ways, the animatableData is a read-write var.
By `setting` of this var is the animation system telling the Shape/VM `which "piece" to draw`
The `getting` of this var is the animation system getting the `start/end points` of an animation.

Usually this is a computed var (though it does not have to be).
We might well not want to use the name "animatableData" in our Shape/VM code
(we want to use variable names that are more descriptive of what that data is to us).
So the get/set very often just gets/sets some other var(s)
(essentially exposing them to the animation system with a different name).

