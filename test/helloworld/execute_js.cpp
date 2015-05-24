#include "execute_js.h"

#include <JavaScriptCore/JavaScriptCore.h>


std::string execute_js(std::string scriptString)
{
	std::string returnResult;

	// Create a new context.
	JSGlobalContextRef context = JSGlobalContextCreate(NULL);

	// Create a string containing the JavaScript source code.
	JSStringRef source = JSStringCreateWithUTF8CString(scriptString.c_str());

	// Run the script source to get the result.
	JSValueRef result = JSEvaluateScript(context, source, NULL, NULL, 1, NULL);

	// Convert the result to an UTF8 string.
	JSStringRef string = JSValueToStringCopy(context, result, NULL);
	size_t cStrSize = JSStringGetMaximumUTF8CStringSize(string);
	returnResult.reserve(cStrSize);

	JSStringGetUTF8CString(string, &returnResult[0], cStrSize);
	JSStringRelease(string);

	// Dispose of the string and context
	JSStringRelease(source);
	JSGlobalContextRelease(context);

	// Return the resulting string
	return returnResult;
}