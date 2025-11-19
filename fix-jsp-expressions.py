import re

# Read the file
with open('C:/Users/AD/Downloads/demo/src/main/webapp/search.jsp', 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern to find scriptlet blocks and replace JSP expressions with Java code
def fix_scriptlet(match):
    scriptlet = match.group(1)
    # Replace ${pageContext.request.contextPath} with " + request.getContextPath() + "
    fixed = scriptlet.replace('${pageContext.request.contextPath}', '" + request.getContextPath() + "')
    return '<% ' + fixed + ' %>'

# Replace inside scriptlet blocks only
content = re.sub(r'<%\s+(.*?)\s+%>', fix_scriptlet, content, flags=re.DOTALL)

# Write back
with open('C:/Users/AD/Downloads/demo/src/main/webapp/search.jsp', 'w', encoding='utf-8') as f:
    f.write(content)

print("✓ Fixed JSP expressions in scriptlet blocks")
