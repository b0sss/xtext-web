/*******************************************************************************
 * Copyright (c) 2015 itemis AG (http://www.itemis.eu) and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *******************************************************************************/
package org.eclipse.xtext.web.server.persistence

import com.google.inject.Provider
import java.io.IOException
import java.io.OutputStreamWriter
import javax.inject.Inject
import org.eclipse.emf.common.util.WrappedException
import org.eclipse.xtext.parser.IEncodingProvider
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.resource.XtextResourceSet
import org.eclipse.xtext.web.server.model.XtextWebDocument

class FileResourceHandler implements IServerResourceHandler {
	
	@Inject IResourceBaseProvider resourceBaseProvider
	
	@Inject Provider<XtextResourceSet> resourceSetProvider
	
	@Inject IEncodingProvider encodingProvider
	
	override get(String resourceId) throws IOException {
		try {
			val uri = resourceBaseProvider.getFileURI(resourceId)
			val resourceSet = resourceSetProvider.get()
			val resource = resourceSet.getResource(uri, true) as XtextResource
			return new XtextWebDocument(resource, resourceId)
		} catch (WrappedException exception) {
			throw exception.cause
		}
	}
	
	override put(XtextWebDocument.ReadAccess documentAccess) throws IOException {
		try {
			val uri = resourceBaseProvider.getFileURI(documentAccess.document.resourceId)
			val outputStream = documentAccess.resource.resourceSet.URIConverter.createOutputStream(uri)
			val writer = new OutputStreamWriter(outputStream, encodingProvider.getEncoding(uri))
			writer.write(documentAccess.text)
			writer.close
		} catch (WrappedException exception) {
			throw exception.cause
		}
	}
	
}