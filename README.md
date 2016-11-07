Problem Description:
Our Flex Payroll application slowed down considerably coinciding with the release of Flash Player 23.
We've spent some time tracking down the source of this degradation - it appears that instantiating flash.display.Shape or any child class in a recursive function is much slower in Flash Player 23 than it was previously. Our Splunk logs indicate this is the case in Chrome/Firefox/IE - though so far we've only tested this locally in IE.
 
Steps to Reproduce:
See attached file ShapeInstantiationDegradation.as or https://github.com/jrkhan/shape-instantiation-degradation for a Flash Builder project.

1) Instantiate a large number of flash.display.Shape within a recursive function to around a depth of ~2,000 (making sure we do not cause a stack overflow) 
2) Measure time it takes using getTimer() 
3) Check the results in a browser using Flash Player 23
4) Downgrade to Flash Player 22 and run the same test in the same browser.

Actual Result:
Flash Player 23 takes significantly longer to instantiate these Shapes as does Flash Player 22.
Also, the deeper we are in the call stack, the more noticeable the degradation seems to be.

Expected Result:
It should not be significantly (5-10x) more expensive to instantiate a Shape in a recursive function than an iterative one. 
Flash Player 23 should not be significantly slower at this than Flash Player 22.

Any Workarounds:
Do not instantiate Shape (or any subclass) while deep in a call stack - there are many patterns that can be used to avoid this.