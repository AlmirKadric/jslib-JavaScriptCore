#import "ios_appDelegate.h"
#import "execute_js.h"


@interface AppDelegate ()
@end


@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Initialize default window
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];

	// Create new UITextView and set initial text
	float statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
	float textViewWidth = self.window.frame.size.width;
	float textViewHeight = self.window.frame.size.height - statusHeight;

	UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(0, statusHeight, textViewWidth, textViewHeight)];
	textView.text = [NSString stringWithFormat: @"RUNNING TESTS:\n"];
	[self.window addSubview: textView];

	// Execute "'Hello' + ', World!'" string and print it
	NSString * result = [NSString stringWithFormat: @"\t1: %s\n", execute_js("'Hello' + ', World!'").c_str()];
	textView.text = [textView.text stringByAppendingString:result];
    [textView setNeedsDisplay];

	return YES;
}
@end