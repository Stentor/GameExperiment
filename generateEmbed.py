#! /usr/bin/python
import os, sys, os.path

header="""package 
{
	import com.pblabs.engine.resource.*;
	
	public class EmbedResource extends ResourceBundle
	{
	"""
	
footer="""
	}
}
"""
def formatFile(file):
	file=file.replace('/','_')
	file=file.replace('.','_')
	file=file.replace('-','_')
	file=file.replace(' ','_')
	return '__'+file.upper()

print "Generating embed script..."
output=file("src/EmbedResource.as","w")
output.write(header)
for root, subFolders, files in os.walk('assets'):
	for file in files:
		extension=file.split('.')[-1]
		
		if (extension.lower() in ("xml","pbelevel","tmx")):
			output.write("""
		[Embed(source="%s",mimeType="application/octet-stream")]
		public var %s:Class;		
			"""%(os.path.join('..',root,file),formatFile(os.path.join(root,file))))
			
		elif (extension.lower() in ("ttf","otf")):
			print "Skipping Font %s"%(file)
		
		else:
			output.write("""
		[Embed(source="%s")]
		public var %s:Class;		
			"""%(os.path.join('..',root,file),formatFile(os.path.join(root,file))))
output.write(footer)
output.close()
print "Done !"
