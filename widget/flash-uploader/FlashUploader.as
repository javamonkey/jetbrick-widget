package {

  import flash.display.*;
  import flash.events.*;
  import flash.external.ExternalInterface;
  import flash.net.*;
  import flash.utils.*;
  import flash.system.Capabilities;

  public class FlashUploader extends Sprite {
	private var debugEnabled:Boolean = false;
	
    private var button:Sprite;
    private var flashvars:Object;
    private var parameters:Object;

    // constructor, setup event listeners and external interfaces
    public function FlashUploader() {

      // Align the stage to top left
      stage.align = "TL";
      stage.scaleMode = "noScale";

      // Get the flashvars
      flashvars = LoaderInfo(this.root.loaderInfo).parameters;
      parameters = null;

	  if (flashvars.debug != null) {
		debugEnabled = true;
	  }
	  
	  if (debugEnabled) {
		ExternalInterface.call("flash_uploader_dispatch_event", "debug", {"flashvars": flashvars});
	  }
	  
      // Allow the swf object to be run on any domain, for when the site hosts the file on a separate server
      if (flashvars.trustedDomain) {
        flash.system.Security.allowDomain(flashvars.trustedDomain.split("\\").join("\\\\"));
      }

      // invisible button covers entire stage
      button = new Sprite();
      button.buttonMode = true;
      button.useHandCursor = true;
      button.graphics.beginFill(0xCCFF00);
      button.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      button.alpha = 0.0;
      addChild(button);

      // Adding the event listeners
      button.addEventListener(MouseEvent.CLICK, mouseClick);
      button.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
      button.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
      button.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
      button.addEventListener(MouseEvent.MOUSE_UP, mouseUp);

      // external functions
      ExternalInterface.addCallback("abort", abort);
      ExternalInterface.addCallback("setRequestData", setRequestData);
      ExternalInterface.addCallback("setHandCursor", setHandCursor);
      ExternalInterface.addCallback("setSize", setSize);
	  ExternalInterface.addCallback("debug", debug);

      // signal to the browser that we are ready
      ExternalInterface.call("flash_uploader_dispatch_event", "load", eventData());
    }

    private function mouseOver(event:MouseEvent): void {
      ExternalInterface.call("flash_uploader_dispatch_event", "mouseover", eventData(event));
    }

    private function mouseOut(event:MouseEvent): void {
      ExternalInterface.call("flash_uploader_dispatch_event", "mouseout", eventData(event));
    }

    private function mouseDown(event:MouseEvent): void {
      ExternalInterface.call("flash_uploader_dispatch_event", "mousedown", eventData(event));
    }

    private function mouseUp(event:MouseEvent): void {
      ExternalInterface.call("flash_uploader_dispatch_event", "mouseup", eventData(event));
    }

    private function mouseClick(event:MouseEvent): void {
	  parameters = null;
	  
	  // client should be invork setRequestData() when recieved dataRequested event.
	  ExternalInterface.call("flash_uploader_dispatch_event", "dataRequested", eventData(event));
  
	  if (debugEnabled) {
		ExternalInterface.call("flash_uploader_dispatch_event", "debug", {"parameters": parameters});
	  }
	  
	  if (parameters == null) {
        var data:Object = eventData(event);
        data.errorText = "no parameters are set when dataRequested trigger.";
        ExternalInterface.call("flash_uploader_dispatch_event", "ioError", data);
        return;
      }
	 
      var file:FileReference = new FileReference();
      parameters.file = file;

      configureListeners(file);

      var filters:Array = [];
      var description:String = parameters["filter-description"] || flashvars["filter-description"] || "All Supported formats";
      var extension:String = parameters["filter-extension"] || flashvars["filter-extension"];

      if (extension) {
        filters.push(new FileFilter(description, extension));
      } else {
        filters.push(new FileFilter("All Files", "*.*"));
        filters.push(new FileFilter("Image Files", "*.jpg;*.gif;*.png"));
        filters.push(new FileFilter("Office Files", "*.doc;*.docx;*.xls;*.xlsx;*.ppt;*.pptx"));
        filters.push(new FileFilter("Compress Files", "*.zip;*.rar;*.gz;*.7z"));
      }
	  
	  ExternalInterface.call("flash_uploader_dispatch_event", "ioError", filters);

      file.browse(filters);
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
      dispatcher.addEventListener(Event.SELECT, selectHandler);
      dispatcher.addEventListener(Event.CANCEL, cancelHandler);
      dispatcher.addEventListener(Event.OPEN, openHandler);
      dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
      dispatcher.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
      dispatcher.addEventListener(Event.COMPLETE, completeHandler);
      dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
      dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }

    private function selectHandler(event:Event):void {
      var file:FileReference = FileReference(event.target);
      ExternalInterface.call("flash_uploader_dispatch_event", "select", eventData(event));

      var request:URLRequest = new URLRequest();
      request.url = parameters.url || flashvars.url;
      request.method = URLRequestMethod.POST;
      file.upload(request);
    }	
    
    private function openHandler(event:Event):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "open", eventData(event));
    }

    private function cancelHandler(event:Event):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "cancel", eventData(event));
      parameters = null;
    }

    private function progressHandler(event:ProgressEvent):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "progress", eventData(event));
    }

    private function uploadCompleteDataHandler(event:DataEvent):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "uploadCompleteData", eventData(event));
    }

    private function completeHandler(event:Event):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "complete", eventData(event));
      parameters = null;
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "ioError", eventData(event));
      parameters = null;
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
      ExternalInterface.call("flash_uploader_dispatch_event", "securityError", eventData(event));
      parameters = null;
    }

    private function eventData(event:Event = void):Object {
      var data:Object = {
        flashVersion : Capabilities.version
      }

      if (event) {
        if (event is MouseEvent) {
          var e1:MouseEvent = MouseEvent(event);
          data.altKey = e1.altKey;
          data.ctrlKey = e1.ctrlKey;
          data.shiftKey = e1.shiftKey;
        } else if (event is ProgressEvent) {
          var e2:ProgressEvent = ProgressEvent(event);
          data.bytesLoaded = e2.bytesLoaded;
          data.bytesTotal = e2.bytesTotal;
        } else if (event is DataEvent) {
          var e3:DataEvent = DataEvent(event);
          data.data = e3.data;
        } else if (event is IOErrorEvent) {
          var e4:IOErrorEvent = IOErrorEvent(event);
          data.errorCode = e4.errorID;
          data.errorText = e4.text;
        } else if (event is SecurityErrorEvent) {
          var e5:SecurityErrorEvent = SecurityErrorEvent(event);
          data.errorText = e5.text;
        }

        if (event.target is FileReference) {
          var file:FileReference = FileReference(event.target);
		  try {
			  data.name = file.name;
			  data.size = file.size;
			  data.type = file.type;
			  data.creationDate  = file.creationDate ;
			  data.modificationDate = file.modificationDate;
		  } catch(e) {  
		  }
        }
      }
      return data;
    }

    public function abort(): void {
      if (parameters != null && parameters.file != null) {
        FileReference(parameters.file).cancel();
      }
    }

    public function setRequestData(parameters:Object): void {
      this.parameters = parameters;
    }

    public function setHandCursor(enabled:Boolean): void {
      button.useHandCursor = enabled;
    }

    public function setSize(width:Number, height:Number): void {
      button.width = width;
      button.height = height;
    }
 
 	public function debug(): void {
      debugEnabled = true;
    }

  }
}