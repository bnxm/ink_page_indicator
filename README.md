# Ink Page Indicator

A package that offers various page indicators inlcuding a flutter implementation of the Ink Page Indicator. See below for more examples.

<p style="text-align:center">
    <img width="356px" alt="Ink Page Indicator" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/ink_demo.gif"/>
</p>

## Installing

Add it to your `pubspec.yaml` file:
```yaml
dependencies:
  ink_page_indicator: ^0.1.0
```
Install packages from the command line
```
flutter packages get
```

## Usage

As of now there are two `PageIndicators`: `InkPageIndicator` and `LeapingPageIndicator`. You can see examples of them below.

Every `PageIndicator` requires an instance of `PageIndicatorController` which is a `PageController` that you should assign to your `PageView`. This allows the `PageIndicator` to calculate the page count and handle page animations properly.

```dart
PageIndicatorController controller;

@override
void initState() {
  super.initState();
  controller = PageIndicatorController();
}

// Assign to PageView
PageView(
  controller: controller,
  children: children,
),
```

### Ink Page Indicator

The `InkPageIndicator` comes with four different styles that you can define using the `style` parameter:

<table>
  <tr>
    <td>
      <img width="100%" alt="InkStyle.normal" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/ink_demo.gif"/>
    </td>
    <td width="25%">
      <img width="100%" alt="InkStyle.simple" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/simple_demo.gif"/>
    </td>
    <td width="25%">
    <img width="100%" alt="InkStyle.transition" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/translate_demo.gif"/>
    </td>
    <td width="25%">
          <img width="100%" alt="InkStyle.translate" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/transition_demo.gif"/>
    </td>
  </tr>
  <tr>
    <td width="25%">
      InkStyle.normal
    </td>
    <td width="25%">
      InkStyle.simple
    </td>
    <td width="25%">
      InkStyle.translate
    </td>
    <td width="25%">
      InkStyle.transition
    </td>
  </tr>
</table>

#### Example

```dart
InkPageIndicator(
  gap: 32,
  padding: 16,
  shape: IndicatorShape.circle(13),
  inactiveColor: Colors.grey.shade500,
  activeColor: Colors.grey.shade700,
  inkColor: Colors.grey.shade400,
  controller: controller,
  style: style,
)
```

### LeapingPageIndicator

A `PageIndicator` that jumps between the each of its items.

<img width="356px" alt="InkStyle.normal" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/leap_demo.gif"/>

#### Example

```dart
LeapingPageIndicator(
    controller: controller,
    gap: 32,
    padding: 16,
    leapHeight: 32,
    shape: shape,
    activeShape: activeShape,
    inactiveColor: Colors.grey.shade400,
    activeColor: Colors.grey.shade700,
  ),
)
```

### Shapes

You can specify different `IndicatorShapes` for inactive and active indicators and the `PageIndicator` will interpolate between them as exemplified below.

<img width="356px" alt="An InkPageIndicator with different shapes using InkStyle.transition" src="https://raw.githubusercontent.com/BendixMa/ink_page_indicator/master/assets/shape_demo.gif"/>

```dart
final shape = IndicatorShape(
  width: 12,
  height: 20,
  borderRadius: BorderRadius.circular(0),
);

final activeShape = IndicatorShape(
  width: 12,
  height: 40,
  borderRadius: BorderRadius.circular(0),
);

InkPageIndicator(
    controller: controller,
    gap: 32,
    padding: 16,
    shape: shape,
    style: InkStyle.transition,
    activeShape: activeShape,
    inactiveColor: Colors.grey.shade400,
    activeColor: Colors.grey.shade700,
  ),
)
```