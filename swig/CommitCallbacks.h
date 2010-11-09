class CommitCallbacks {

  private:
    PatchMessageReportReceiver _messageReceiver;
    PatchScriptReportReceiver _scriptReceiver;
    RemoveResolvableReportReceiver _removeReceiver;
    InstallResolvableReportReceiver _installReceiver;
    Target_Type _instance;

  public:
    CommitCallbacks()
     : _instance(Target_Null)
    {
      _messageReceiver.connect();
      _scriptReceiver.connect();
      _installReceiver.connect();
      _removeReceiver.connect();
    }

    ~CommitCallbacks()
    {
      _removeReceiver.disconnect();
      _installReceiver.disconnect();
      _scriptReceiver.disconnect();
      _messageReceiver.disconnect();
      disconnect();
    }
   /*
    * Connect callback to receiver instance
    * Pass NULL receiver to disconnect
    * 
    */
    void connect(Target_Type instance) {
//	    fprintf(stderr, "connect(%p)\n", instance);
      disconnect();
      if (instance) {
	_instance = instance;
	Target_INCREF(_instance);
	_messageReceiver.instance = _instance;
	_scriptReceiver.instance = _instance;
	_installReceiver.instance = _instance;
	_removeReceiver.instance = _instance;
      }
    }
    /*
     * Disconnect receiver instance
     * 
     */
    void disconnect() {
//	    fprintf(stderr, "disconnect(%p)\n", _instance);
      if (_instance != Target_Null) {
	_messageReceiver.instance = Target_Null;
	_scriptReceiver.instance = Target_Null;
	_installReceiver.instance = Target_Null;
	_removeReceiver.instance = Target_Null;
	Target_DECREF(_instance);
        _instance = Target_Null;
      }
    }
    /*
     * Get current receiver instance
     * 
     */
    Target_Type receiver() {
//	    fprintf(stderr, "receiver(%p)\n", _instance);
      return _instance;
    }
};


/*
 * A (dummy) commit callback emitter used for testing only
 * 
 */

class CommitCallbacksEmitter {
  private:
    callback::SendReport<target::rpm::RemoveResolvableReport> remove_resolvable;
    callback::SendReport<target::PatchMessageReport> patch_message;
    callback::SendReport<target::PatchScriptReport> patch_script;
    callback::SendReport<target::rpm::InstallResolvableReport> install_resolvable;
  public:
    void remove_start(zypp::ResObject::constPtr resobj)
    {
      remove_resolvable->start( resobj );
    }
};

