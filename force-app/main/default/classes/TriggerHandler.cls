/**
* @description Trigger framework for use with implementing handler classes
* @author <p>Copyright (c) 2013 Kevin M. O'Hara</p>
* 
* <p>Code repository:  https://github.com/kevinohara80/sfdc-trigger-framework/</p>
* 
* <p>LICENSE:</br></p>
* <p>Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or
* sell copies of the Software, and to permit persons to whom
* the Software is furnished to do so, subject to the following
* conditions:</p>
*
* <p>The above copyright notice and this permission notice shall
* be included in all copies or substantial portions of the
* Software.</p>
*
* <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
* KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
* OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>
*/
public virtual class TriggerHandler {

  /** static map of handlername, times run() was invoked */
  private static Map<String, LoopCount> loopCountMap;
  
  /** static map of handlers that are bypassed */
  private static Set<String> bypassedHandlers;

  /** the current context of the trigger, overridable in tests */
  @TestVisible
  private TriggerContext context;

  /** the current context of the trigger, overridable in tests */
  @TestVisible
  private Boolean isTriggerExecuting;

  /** list of objects to insert [Mike Crosby, 2015-01-12] */
  protected List<SObject> toInsert;

  /** list of objects to update [Mike Crosby, 2015-01-12] */
  protected List<SObject> toUpdate;

  /** list of objects to delete [Mike Crosby, 2015-01-12] */
  protected List<SObject> toDelete;

  /** static initialization */
  static {
    loopCountMap = new Map<String, LoopCount>();
    bypassedHandlers = new Set<String>();
  }
  
  /** constructor */
  public TriggerHandler() {
    this.setTriggerContext();
  }

  /* public instance methods */

  /** 
  * Main method that will be called during execution. Validation of the run occurs first,
  * then initializing of DML object lists, triggering of appropriate trigger context logic,
  * and finally triggering of the DML operations for any records that need to be inserted/
  * updated/deleted
  */
  public void run() {

    if(!validateRun()) return;

    addToLoopCount();

    //Mike Crosby, 2015-01-12
    initDMLLists();

    // dispatch to the correct handler method
    if(this.context == TriggerContext.BEFORE_INSERT) {
      this.beforeInsert();
    } else if(this.context == TriggerContext.BEFORE_UPDATE) {
      this.beforeUpdate();
    } else if(this.context == TriggerContext.BEFORE_DELETE) {
      this.beforeDelete();
    } else if(this.context == TriggerContext.AFTER_INSERT) {
      this.afterInsert();
    } else if(this.context == TriggerContext.AFTER_UPDATE) {
      this.afterUpdate();
    } else if(this.context == TriggerContext.AFTER_DELETE) {
      this.afterDelete();
    } else if(this.context == TriggerContext.AFTER_UNDELETE) {
      this.afterUndelete();
    }

    //Mike Crosby, 2015-01-12
    handleDML();

  }

  /**
  * Sets maximum times handler can be called by trigger during an execution
  * to help prevent issues involving recursion (helps ensure trigger only runs
  * once)
  * @param max the number of times the handler can be called
  */
  public void setMaxLoopCount(Integer max) {
    String handlerName = getHandlerName();
    if(!TriggerHandler.loopCountMap.containsKey(handlerName)) {
      TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
    } else {
      TriggerHandler.loopCountMap.get(handlerName).setMax(max);
    }
  }
  
  /**
  * Sets the loop count to -1 to remove the maximum limit
  */
  public void clearMaxLoopCount() {
    this.setMaxLoopCount(-1);
  }

  /* public static methods */

  /**
  * Instructs the trigger handler to ignore/bypass a trigger handler of the given
  * name. Useful if an insert/update is initiated for different object and the 
  * trigger handler for that object should not run.
  * @param handlerName name of trigger handler class that should be ignored
  */
  public static void bypass(String handlerName) {
    TriggerHandler.bypassedHandlers.add(handlerName);
  }

  /**
  * Removes the trigger handler bypass that has been previously set to allow for
  * the handler to run
  * @param handlerName name of trigger handler that should be allowed to run
  */
  public static void clearBypass(String handlerName) {
    TriggerHandler.bypassedHandlers.remove(handlerName);
  }

  /**
  * Tests to see if a particular trigger handler has been set to be bypassed
  * @param handlerName name of trigger handler to test
  * @return TRUE if trigger handler is set to bypass; FALSE if not
  */
  public static Boolean isBypassed(String handlerName) {
    return TriggerHandler.bypassedHandlers.contains(handlerName);
  }

  /**
  * Clears all trigger handler bypasses that have been set
  */
  public static void clearAllBypasses() {
    TriggerHandler.bypassedHandlers.clear();
  }

  /* private instance methods */

  /**
  * Initializes DML lists [Mike Crosby, 2015-01-12]
  */
  @TestVisible
  private void initDMLLists() {
  	this.toInsert = new List<SObject>();
  	this.toUpdate = new List<SObject>();
  	this.toDelete = new List<SObject>();
  }

  /**
  * Handles DML calls after processing has occurred [Mike Crosby, 2015-01-12]
  */
  private void handleDML() {
  	if(this.toInsert != null && this.toInsert.size() > 0) {
  	  insert toInsert;
  	}
  	
  	if(this.toUpdate != null && this.toUpdate.size() > 0) {
  	  update toUpdate;
  	}
  	
  	if(this.toDelete != null && this.toDelete.size() > 0) {
  		Set<Id> idsToDelete = new Set<Id>();
  		for(SObject o : this.toDelete) {
  			idsToDelete.add(o.Id);
  		}
  		List<Id> ids = new List<Id>();
  		ids.addAll(idsToDelete);
  	 	Database.delete(ids);
  	}
  }

  /**
  * Sets default trigger context
  */
  @TestVisible
  private void setTriggerContext() {
    this.setTriggerContext(null, false);
  }

  /**
  * Sets trigger context
  * @param ctx the context of the trigger (e.g. 'before insert', 'after insert', ...)
  * @param testMode TRUE if running in test; FALSE is not
  */
  @TestVisible
  private void setTriggerContext(String ctx, Boolean testMode) {
    if(!Trigger.isExecuting && !testMode) {
      this.isTriggerExecuting = false;
      return;
    } else {
      this.isTriggerExecuting = true;
    }
    
    if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
        (ctx != null && ctx == 'before insert')) {
      this.context = TriggerContext.BEFORE_INSERT;
    } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
        (ctx != null && ctx == 'before update')){
      this.context = TriggerContext.BEFORE_UPDATE;
    } else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
        (ctx != null && ctx == 'before delete')) {
      this.context = TriggerContext.BEFORE_DELETE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
        (ctx != null && ctx == 'after insert')) {
      this.context = TriggerContext.AFTER_INSERT;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
        (ctx != null && ctx == 'after update')) {
      this.context = TriggerContext.AFTER_UPDATE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
        (ctx != null && ctx == 'after delete')) {
      this.context = TriggerContext.AFTER_DELETE;
    } else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
        (ctx != null && ctx == 'after undelete')) {
      this.context = TriggerContext.AFTER_UNDELETE;
    }
  }

  /**
  * Increments the loop count; throws exception if max loop count is set and has 
  * been reached
  */
  @TestVisible
  private void addToLoopCount() {
    String handlerName = getHandlerName();
    if(TriggerHandler.loopCountMap.containsKey(handlerName)) {
      Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
      if(exceeded) {
        Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
        throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
      }
    }
  }

  /**
  * Checks to ensure if this trigger should continue to run; throws error if trigger
  * is not executing or the context is null
  * @return FALSE if trigger handler is bypassed; TRUE otherwise
  */
  @TestVisible
  private Boolean validateRun() {
    if(!this.isTriggerExecuting || this.context == null) {
      throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
    }
    if(TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      return false;
    }
    return true;
  }

  /**
  * Returns the current trigger handler name
  * @return trigger handler name
  */
  @TestVisible
  private String getHandlerName() {
    return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
  }

  /* context methods */

  // context-specific methods for override
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void beforeInsert(){}
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void beforeUpdate(){}
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void beforeDelete(){}
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void afterInsert(){}
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void afterUpdate(){}
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void afterDelete(){}
  /**
  * Context-specific methods for override
  */
  @TestVisible
  protected virtual void afterUndelete(){}

  /* inner classes */

  /**
  * Inner class for managing the loop count per handler
  */
  @TestVisible
  private class LoopCount {
  	/** Maximum loops allowed */
    private Integer max;
    /** Current count */
    private Integer count;

    /**
    * Constructor which sets default max to 5 and count to 0
    */
    public LoopCount() {
      this.max = 5;
      this.count = 0;
    }

    /**
    * Constructor which sets default count to 0
    * @param max maximum number of loops allowed
    */
    public LoopCount(Integer max) {
      this.max = max;
      this.count = 0;
    }

    /**
    * Increments the count
    * @return TRUE if maximum number of loops exceeded; FALSE if not
    */
    public Boolean increment() {
      this.count++;
      return this.exceeded();
    }

    /**
    * Determines if maximum number of loops has been exceeded
    * @return TRUE if maximum number of loops exceeded; FALSE if not
    */
    public Boolean exceeded() {
      if(this.max < 0) return false;
      if(this.count > this.max) {
        return true;
      }
      return false;
    }

    /**
    * Returns the maximum number of loops allowed
    * @return max
    */
    public Integer getMax() {
      return this.max;
    }

    /**
    * Returns the current loop count
    * @return count
    */
    public Integer getCount() {
      return this.count;
    }

    /**
    * Sets the maximum number of loops allowed
    * @param max maximum number of loops
    */
    public void setMax(Integer max) {
      this.max = max;
    }
  }

  /** 
  * Possible trigger contexts: BEFORE_INSERT, BEFORE_UPDATE, 
  * BEFORE_DELETE, AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
  * AFTER_UNDELETE 
  */
  @TestVisible
  private enum TriggerContext {
    BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
    AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
    AFTER_UNDELETE
  }

  /** Exception class */
  public class TriggerHandlerException extends Exception {}

}