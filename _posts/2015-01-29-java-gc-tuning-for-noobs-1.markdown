---
layout: post
title:  "Java GC Tuning for Noobs: Part 1"
date:   2015-01-29 19:43:08
categories: java gc
---

{% include gc.html %}

The JVM is voodoo. [Garbage collection]({% post_url 2015-01-25-why-garbage-collection %}) is *double voodoo*. How is one to make sense of all of this shit? I'm not sure I know all the answers, but I can help you get on your way.

# JVM Options

Whether it's good ol' fashioned Java or newfangled [Scala](http://scala-lang.org) or [Clojure](http://clojure.org) code, you are still running on top of the JVM.

You can send an option to the JVM to get a list of all the flags and their default values using `java -XX:+PrintFlagsFinal`. Note that you can also supply options to see their effect on final flags by including them a la `java -Xmx4G -XX:+PrintFlagsFinal`.

Here's [Oracle's documentation on JVM options](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html). Note that this is for Java 7, but Java 8 has links right at the top.

# Defaults

Soooo this is gonna be a giant box of shit, but we're gonna refer back to it in other post so here goes!

Here's the output of `java -XX:+PrintFlagsFinal` from one of my production machines:

<pre>
java -XX:+PrintFlagsFinal
[Global flags]
    uintx AdaptivePermSizeWeight                    = 20              {product}
    uintx AdaptiveSizeDecrementScaleFactor          = 4               {product}
    uintx AdaptiveSizeMajorGCDecayTimeScale         = 10              {product}
    uintx AdaptiveSizePausePolicy                   = 0               {product}
    uintx AdaptiveSizePolicyCollectionCostMargin    = 50              {product}
    uintx AdaptiveSizePolicyInitializingSteps       = 20              {product}
    uintx AdaptiveSizePolicyOutputInterval          = 0               {product}
    uintx AdaptiveSizePolicyWeight                  = 10              {product}
    uintx AdaptiveSizeThroughPutPolicy              = 0               {product}
    uintx AdaptiveTimeWeight                        = 25              {product}
     bool AdjustConcurrency                         = false           {product}
     bool AggressiveOpts                            = false           {product}
     intx AliasLevel                                = 3               {C2 product}
     bool AlignVector                               = true            {C2 product}
     intx AllocateInstancePrefetchLines             = 1               {product}
     intx AllocatePrefetchDistance                  = -1              {product}
     intx AllocatePrefetchInstr                     = 0               {product}
     intx AllocatePrefetchLines                     = 3               {product}
     intx AllocatePrefetchStepSize                  = 16              {product}
     intx AllocatePrefetchStyle                     = 1               {product}
     bool AllowJNIEnvProxy                          = false           {product}
     bool AllowNonVirtualCalls                      = false           {product}
     bool AllowParallelDefineClass                  = false           {product}
     bool AllowUserSignalHandlers                   = false           {product}
     bool AlwaysActAsServerClassMachine             = false           {product}
     bool AlwaysCompileLoopMethods                  = false           {product}
     bool AlwaysLockClassLoader                     = false           {product}
     bool AlwaysPreTouch                            = false           {product}
     bool AlwaysRestoreFPU                          = false           {product}
     bool AlwaysTenure                              = false           {product}
     bool AssertOnSuspendWaitFailure                = false           {product}
     intx Atomics                                   = 0               {product}
     intx AutoBoxCacheMax                           = 128             {C2 product}
    uintx AutoGCSelectPauseMillis                   = 5000            {product}
     intx BCEATraceLevel                            = 0               {product}
     intx BackEdgeThreshold                         = 100000          {pd product}
     bool BackgroundCompilation                     = true            {pd product}
    uintx BaseFootPrintEstimate                     = 268435456       {product}
     intx BiasedLockingBulkRebiasThreshold          = 20              {product}
     intx BiasedLockingBulkRevokeThreshold          = 40              {product}
     intx BiasedLockingDecayTime                    = 25000           {product}
     intx BiasedLockingStartupDelay                 = 4000            {product}
     bool BindGCTaskThreadsToCPUs                   = false           {product}
     bool BlockLayoutByFrequency                    = true            {C2 product}
     intx BlockLayoutMinDiamondPercentage           = 20              {C2 product}
     bool BlockLayoutRotateLoops                    = true            {C2 product}
     bool BranchOnRegister                          = false           {C2 product}
     bool BytecodeVerificationLocal                 = false           {product}
     bool BytecodeVerificationRemote                = true            {product}
     bool C1OptimizeVirtualCallProfiling            = true            {C1 product}
     bool C1ProfileBranches                         = true            {C1 product}
     bool C1ProfileCalls                            = true            {C1 product}
     bool C1ProfileCheckcasts                       = true            {C1 product}
     bool C1ProfileInlinedCalls                     = true            {C1 product}
     bool C1ProfileVirtualCalls                     = true            {C1 product}
     bool C1UpdateMethodData                        = true            {C1 product}
     intx CICompilerCount                           = 2               {product}
     bool CICompilerCountPerCPU                     = false           {product}
     bool CITime                                    = false           {product}
     bool CMSAbortSemantics                         = false           {product}
    uintx CMSAbortablePrecleanMinWorkPerIteration   = 100             {product}
     intx CMSAbortablePrecleanWaitMillis            = 100             {manageable}
    uintx CMSBitMapYieldQuantum                     = 10485760        {product}
    uintx CMSBootstrapOccupancy                     = 50              {product}
     bool CMSClassUnloadingEnabled                  = false           {product}
    uintx CMSClassUnloadingMaxInterval              = 0               {product}
     bool CMSCleanOnEnter                           = true            {product}
     bool CMSCompactWhenClearAllSoftRefs            = true            {product}
    uintx CMSConcMarkMultiple                       = 32              {product}
     bool CMSConcurrentMTEnabled                    = true            {product}
    uintx CMSCoordinatorYieldSleepCount             = 10              {product}
     bool CMSDumpAtPromotionFailure                 = false           {product}
     bool CMSEdenChunksRecordAlways                 = false           {product}
    uintx CMSExpAvgFactor                           = 50              {product}
     bool CMSExtrapolateSweep                       = false           {product}
    uintx CMSFullGCsBeforeCompaction                = 0               {product}
    uintx CMSIncrementalDutyCycle                   = 10              {product}
    uintx CMSIncrementalDutyCycleMin                = 0               {product}
     bool CMSIncrementalMode                        = false           {product}
    uintx CMSIncrementalOffset                      = 0               {product}
     bool CMSIncrementalPacing                      = true            {product}
    uintx CMSIncrementalSafetyFactor                = 10              {product}
    uintx CMSIndexedFreeListReplenish               = 4               {product}
     intx CMSInitiatingOccupancyFraction            = -1              {product}
     intx CMSInitiatingPermOccupancyFraction        = -1              {product}
     intx CMSIsTooFullPercentage                    = 98              {product}
   double CMSLargeCoalSurplusPercent                = 0.950000        {product}
   double CMSLargeSplitSurplusPercent               = 1.000000        {product}
     bool CMSLoopWarn                               = false           {product}
    uintx CMSMaxAbortablePrecleanLoops              = 0               {product}
     intx CMSMaxAbortablePrecleanTime               = 5000            {product}
    uintx CMSOldPLABMax                             = 1024            {product}
    uintx CMSOldPLABMin                             = 16              {product}
    uintx CMSOldPLABNumRefills                      = 4               {product}
    uintx CMSOldPLABReactivityFactor                = 2               {product}
     bool CMSOldPLABResizeQuicker                   = false           {product}
    uintx CMSOldPLABToleranceFactor                 = 4               {product}
     bool CMSPLABRecordAlways                       = true            {product}
    uintx CMSParPromoteBlocksToClaim                = 16              {product}
     bool CMSParallelInitialMarkEnabled             = false           {product}
     bool CMSParallelRemarkEnabled                  = true            {product}
     bool CMSParallelSurvivorRemarkEnabled          = true            {product}
     bool CMSPermGenPrecleaningEnabled              = true            {product}
    uintx CMSPrecleanDenominator                    = 3               {product}
    uintx CMSPrecleanIter                           = 3               {product}
    uintx CMSPrecleanNumerator                      = 2               {product}
     bool CMSPrecleanRefLists1                      = true            {product}
     bool CMSPrecleanRefLists2                      = false           {product}
     bool CMSPrecleanSurvivors1                     = false           {product}
     bool CMSPrecleanSurvivors2                     = true            {product}
    uintx CMSPrecleanThreshold                      = 1000            {product}
     bool CMSPrecleaningEnabled                     = true            {product}
     bool CMSPrintChunksInDump                      = false           {product}
     bool CMSPrintEdenSurvivorChunks                = false           {product}
     bool CMSPrintObjectsInDump                     = false           {product}
    uintx CMSRemarkVerifyVariant                    = 1               {product}
     bool CMSReplenishIntermediate                  = true            {product}
    uintx CMSRescanMultiple                         = 32              {product}
    uintx CMSRevisitStackSize                       = 1048576         {product}
    uintx CMSSamplingGrain                          = 16384           {product}
     bool CMSScavengeBeforeRemark                   = false           {product}
    uintx CMSScheduleRemarkEdenPenetration          = 50              {product}
    uintx CMSScheduleRemarkEdenSizeThreshold        = 2097152         {product}
    uintx CMSScheduleRemarkSamplingRatio            = 5               {product}
   double CMSSmallCoalSurplusPercent                = 1.050000        {product}
   double CMSSmallSplitSurplusPercent               = 1.100000        {product}
     bool CMSSplitIndexedFreeListBlocks             = true            {product}
     intx CMSTriggerPermRatio                       = 80              {product}
     intx CMSTriggerRatio                           = 80              {product}
     intx CMSWaitDuration                           = 2000            {manageable}
    uintx CMSWorkQueueDrainThreshold                = 10              {product}
     bool CMSYield                                  = true            {product}
    uintx CMSYieldSleepCount                        = 0               {product}
     intx CMSYoungGenPerWorker                      = 67108864        {pd product}
    uintx CMS_FLSPadding                            = 1               {product}
    uintx CMS_FLSWeight                             = 75              {product}
    uintx CMS_SweepPadding                          = 1               {product}
    uintx CMS_SweepTimerThresholdMillis             = 10              {product}
    uintx CMS_SweepWeight                           = 75              {product}
     bool CheckJNICalls                             = false           {product}
     bool ClassUnloading                            = true            {product}
     intx ClearFPUAtPark                            = 0               {product}
     bool ClipInlining                              = true            {product}
    uintx CodeCacheExpansionSize                    = 65536           {pd product}
    uintx CodeCacheFlushingMinimumFreeSpace         = 1536000         {product}
    uintx CodeCacheMinimumFreeSpace                 = 512000          {product}
     bool CollectGen0First                          = false           {product}
     bool CompactFields                             = true            {product}
     intx CompilationPolicyChoice                   = 0               {product}
     intx CompilationRepeat                         = 0               {C1 product}
ccstrlist CompileCommand                            =                 {product}
    ccstr CompileCommandFile                        =                 {product}
ccstrlist CompileOnly                               =                 {product}
     intx CompileThreshold                          = 10000           {pd product}
     bool CompilerThreadHintNoPreempt               = true            {product}
     intx CompilerThreadPriority                    = -1              {product}
     intx CompilerThreadStackSize                   = 0               {pd product}
    uintx ConcGCThreads                             = 0               {product}
     intx ConditionalMoveLimit                      = 3               {C2 pd product}
     bool ConvertSleepToYield                       = true            {pd product}
     bool ConvertYieldToSleep                       = false           {product}
     bool CreateMinidumpOnCrash                     = false           {product}
     bool CriticalJNINatives                        = true            {product}
     bool DTraceAllocProbes                         = false           {product}
     bool DTraceMethodProbes                        = false           {product}
     bool DTraceMonitorProbes                       = false           {product}
     bool Debugging                                 = false           {product}
    uintx DefaultMaxRAMFraction                     = 4               {product}
     intx DefaultThreadPriority                     = -1              {product}
     intx DeferPollingPageLoopCount                 = -1              {product}
     intx DeferThrSuspendLoopCount                  = 4000            {product}
     bool DeoptimizeRandom                          = false           {product}
     bool DisableAttachMechanism                    = false           {product}
     bool DisableExplicitGC                         = false           {product}
     bool DisplayVMOutputToStderr                   = false           {product}
     bool DisplayVMOutputToStdout                   = false           {product}
     bool DoEscapeAnalysis                          = true            {C2 product}
     bool DontCompileHugeMethods                    = true            {product}
     bool DontYieldALot                             = false           {pd product}
     bool DumpSharedSpaces                          = false           {product}
     bool EagerXrunInit                             = false           {product}
     intx EliminateAllocationArraySizeLimit         = 64              {C2 product}
     bool EliminateAllocations                      = true            {C2 product}
     bool EliminateLocks                            = true            {C2 product}
     bool EliminateNestedLocks                      = true            {C2 product}
     intx EmitSync                                  = 0               {product}
     bool EnableTracing                             = false           {product}
    uintx ErgoHeapSizeLimit                         = 0               {product}
    ccstr ErrorFile                                 =                 {product}
    ccstr ErrorReportServer                         =                 {product}
     bool EstimateArgEscape                         = true            {product}
     bool ExplicitGCInvokesConcurrent               = false           {product}
     bool ExplicitGCInvokesConcurrentAndUnloadsClasses  = false           {product}
     bool ExtendedDTraceProbes                      = false           {product}
     bool FLSAlwaysCoalesceLarge                    = false           {product}
    uintx FLSCoalescePolicy                         = 2               {product}
   double FLSLargestBlockCoalesceProximity          = 0.990000        {product}
     bool FailOverToOldVerifier                     = true            {product}
     bool FastTLABRefill                            = true            {product}
     intx FenceInstruction                          = 0               {ARCH product}
     intx FieldsAllocationStyle                     = 1               {product}
     bool FilterSpuriousWakeups                     = true            {product}
     bool ForceNUMA                                 = false           {product}
     bool ForceTimeHighResolution                   = false           {product}
     intx FreqInlineSize                            = 325             {pd product}
   double G1ConcMarkStepDurationMillis              = 10.000000       {product}
    uintx G1ConcRSHotCardLimit                      = 4               {product}
    uintx G1ConcRSLogCacheSize                      = 10              {product}
     intx G1ConcRefinementGreenZone                 = 0               {product}
     intx G1ConcRefinementRedZone                   = 0               {product}
     intx G1ConcRefinementServiceIntervalMillis     = 300             {product}
    uintx G1ConcRefinementThreads                   = 0               {product}
     intx G1ConcRefinementThresholdStep             = 0               {product}
     intx G1ConcRefinementYellowZone                = 0               {product}
    uintx G1ConfidencePercent                       = 50              {product}
    uintx G1HeapRegionSize                          = 0               {product}
    uintx G1HeapWastePercent                        = 10              {product}
    uintx G1MixedGCCountTarget                      = 8               {product}
     intx G1RSetRegionEntries                       = 0               {product}
    uintx G1RSetScanBlockSize                       = 64              {product}
     intx G1RSetSparseRegionEntries                 = 0               {product}
     intx G1RSetUpdatingPauseTimePercent            = 10              {product}
     intx G1RefProcDrainInterval                    = 10              {product}
    uintx G1ReservePercent                          = 10              {product}
    uintx G1SATBBufferEnqueueingThresholdPercent    = 60              {product}
     intx G1SATBBufferSize                          = 1024            {product}
     intx G1UpdateBufferSize                        = 256             {product}
     bool G1UseAdaptiveConcRefinement               = true            {product}
    uintx GCDrainStackTargetSize                    = 64              {product}
    uintx GCHeapFreeLimit                           = 2               {product}
    uintx GCLockerEdenExpansionPercent              = 5               {product}
     bool GCLockerInvokesConcurrent                 = false           {product}
    uintx GCLogFileSize                             = 0               {product}
    uintx GCPauseIntervalMillis                     = 0               {product}
    uintx GCTaskTimeStampEntries                    = 200             {product}
    uintx GCTimeLimit                               = 98              {product}
    uintx GCTimeRatio                               = 99              {product}
    uintx HeapBaseMinAddress                        = 2147483648      {pd product}
     bool HeapDumpAfterFullGC                       = false           {manageable}
     bool HeapDumpBeforeFullGC                      = false           {manageable}
     bool HeapDumpOnOutOfMemoryError                = false           {manageable}
    ccstr HeapDumpPath                              =                 {manageable}
    uintx HeapFirstMaximumCompactionCount           = 3               {product}
    uintx HeapMaximumCompactionInterval             = 20              {product}
    uintx HeapSizePerGCThread                       = 87241520        {product}
     bool IgnoreUnrecognizedVMOptions               = false           {product}
     bool IncrementalInline                         = true            {C2 product}
    uintx InitialCodeCacheSize                      = 2555904         {pd product}
    uintx InitialHeapSize                           = 0               {product}
    uintx InitialRAMFraction                        = 64              {product}
    uintx InitialSurvivorRatio                      = 8               {product}
     intx InitialTenuringThreshold                  = 7               {product}
    uintx InitiatingHeapOccupancyPercent            = 45              {product}
     bool Inline                                    = true            {product}
     intx InlineSmallCode                           = 1000            {pd product}
     bool InsertMemBarAfterArraycopy                = true            {C2 product}
     intx InteriorEntryAlignment                    = 16              {C2 pd product}
     intx InterpreterProfilePercentage              = 33              {product}
     bool JNIDetachReleasesMonitors                 = true            {product}
     bool JavaMonitorsInStackTrace                  = true            {product}
     intx JavaPriority10_To_OSPriority              = -1              {product}
     intx JavaPriority1_To_OSPriority               = -1              {product}
     intx JavaPriority2_To_OSPriority               = -1              {product}
     intx JavaPriority3_To_OSPriority               = -1              {product}
     intx JavaPriority4_To_OSPriority               = -1              {product}
     intx JavaPriority5_To_OSPriority               = -1              {product}
     intx JavaPriority6_To_OSPriority               = -1              {product}
     intx JavaPriority7_To_OSPriority               = -1              {product}
     intx JavaPriority8_To_OSPriority               = -1              {product}
     intx JavaPriority9_To_OSPriority               = -1              {product}
     bool LIRFillDelaySlots                         = false           {C1 pd product}
    uintx LargePageHeapSizeThreshold                = 134217728       {product}
    uintx LargePageSizeInBytes                      = 0               {product}
     bool LazyBootClassLoader                       = true            {product}
     intx LiveNodeCountInliningCutoff               = 20000           {C2 product}
     bool LoadExecStackDllInVMThread                = true            {product}
     intx LoopMaxUnroll                             = 16              {C2 product}
     intx LoopOptsCount                             = 43              {C2 product}
     intx LoopUnrollLimit                           = 60              {C2 pd product}
     intx LoopUnrollMin                             = 4               {C2 product}
     bool LoopUnswitching                           = true            {C2 product}
     bool ManagementServer                          = false           {product}
    uintx MarkStackSize                             = 4194304         {product}
    uintx MarkStackSizeMax                          = 536870912       {product}
     intx MarkSweepAlwaysCompactCount               = 4               {product}
    uintx MarkSweepDeadRatio                        = 5               {product}
     intx MaxBCEAEstimateLevel                      = 5               {product}
     intx MaxBCEAEstimateSize                       = 150             {product}
    uintx MaxDirectMemorySize                       = 0               {product}
     bool MaxFDLimit                                = true            {product}
    uintx MaxGCMinorPauseMillis                     = 18446744073709551615{product}
    uintx MaxGCPauseMillis                          = 18446744073709551615{product}
    uintx MaxHeapFreeRatio                          = 70              {manageable}
    uintx MaxHeapSize                               = 130862280       {product}
     intx MaxInlineLevel                            = 9               {product}
     intx MaxInlineSize                             = 35              {product}
     intx MaxJavaStackTraceDepth                    = 1024            {product}
     intx MaxJumpTableSize                          = 65000           {C2 product}
     intx MaxJumpTableSparseness                    = 5               {C2 product}
     intx MaxLabelRootDepth                         = 1100            {C2 product}
     intx MaxLoopPad                                = 15              {C2 product}
    uintx MaxNewSize                                = 18446744073709551615{product}
     intx MaxNodeLimit                              = 65000           {C2 product}
    uintx MaxPermHeapExpansion                      = 5452592         {product}
    uintx MaxPermSize                               = 87241520        {pd product}
 uint64_t MaxRAM                                    = 137438953472    {pd product}
    uintx MaxRAMFraction                            = 4               {product}
     intx MaxRecursiveInlineLevel                   = 1               {product}
     intx MaxTenuringThreshold                      = 15              {product}
     intx MaxTrivialSize                            = 6               {product}
     intx MaxVectorSize                             = 32              {C2 product}
     bool MethodFlushing                            = true            {product}
     intx MinCodeCacheFlushingInterval              = 30              {product}
    uintx MinHeapDeltaBytes                         = 170392          {product}
    uintx MinHeapFreeRatio                          = 40              {manageable}
     intx MinInliningThreshold                      = 250             {product}
     intx MinJumpTableSize                          = 18              {C2 product}
    uintx MinPermHeapExpansion                      = 340784          {product}
    uintx MinRAMFraction                            = 2               {product}
    uintx MinSurvivorRatio                          = 3               {product}
    uintx MinTLABSize                               = 2048            {product}
     intx MonitorBound                              = 0               {product}
     bool MonitorInUseLists                         = false           {product}
     intx MultiArrayExpandLimit                     = 6               {C2 product}
     bool MustCallLoadClassInternal                 = false           {product}
     intx NUMAChunkResizeWeight                     = 20              {product}
    uintx NUMAInterleaveGranularity                 = 2097152         {product}
     intx NUMAPageScanRate                          = 256             {product}
     intx NUMASpaceResizeRate                       = 1073741824      {product}
     bool NUMAStats                                 = false           {product}
    ccstr NativeMemoryTracking                      = off             {product}
     intx NativeMonitorFlags                        = 0               {product}
     intx NativeMonitorSpinLimit                    = 20              {product}
     intx NativeMonitorTimeout                      = -1              {product}
     bool NeedsDeoptSuspend                         = false           {pd product}
     bool NeverActAsServerClassMachine              = false           {pd product}
     bool NeverTenure                               = false           {product}
     intx NewRatio                                  = 2               {product}
    uintx NewSize                                   = 1363144         {product}
    uintx NewSizeThreadIncrease                     = 5320            {pd product}
     intx NmethodSweepCheckInterval                 = 5               {product}
     intx NmethodSweepFraction                      = 16              {product}
     intx NodeLimitFudgeFactor                      = 1000            {C2 product}
    uintx NumberOfGCLogFiles                        = 0               {product}
     intx NumberOfLoopInstrToAlign                  = 4               {C2 product}
     intx ObjectAlignmentInBytes                    = 8               {lp64_product}
    uintx OldPLABSize                               = 1024            {product}
    uintx OldPLABWeight                             = 50              {product}
    uintx OldSize                                   = 5452592         {product}
     bool OmitStackTraceInFastThrow                 = true            {product}
ccstrlist OnError                                   =                 {product}
ccstrlist OnOutOfMemoryError                        =                 {product}
     intx OnStackReplacePercentage                  = 140             {pd product}
     bool OptimizeFill                              = true            {C2 product}
     bool OptimizePtrCompare                        = true            {C2 product}
     bool OptimizeStringConcat                      = true            {C2 product}
     bool OptoBundling                              = false           {C2 pd product}
     intx OptoLoopAlignment                         = 16              {pd product}
     bool OptoScheduling                            = false           {C2 pd product}
    uintx PLABWeight                                = 75              {product}
     bool PSChunkLargeArrays                        = true            {product}
     intx ParGCArrayScanChunk                       = 50              {product}
    uintx ParGCDesiredObjsFromOverflowList          = 20              {product}
     bool ParGCTrimOverflow                         = true            {product}
     bool ParGCUseLocalOverflow                     = false           {product}
     intx ParallelGCBufferWastePct                  = 10              {product}
    uintx ParallelGCThreads                         = 0               {product}
     bool ParallelGCVerbose                         = false           {product}
    uintx ParallelOldDeadWoodLimiterMean            = 50              {product}
    uintx ParallelOldDeadWoodLimiterStdDev          = 80              {product}
     bool ParallelRefProcBalancingEnabled           = true            {product}
     bool ParallelRefProcEnabled                    = false           {product}
     bool PartialPeelAtUnsignedTests                = true            {C2 product}
     bool PartialPeelLoop                           = true            {C2 product}
     intx PartialPeelNewPhiDelta                    = 0               {C2 product}
    uintx PausePadding                              = 1               {product}
     intx PerBytecodeRecompilationCutoff            = 200             {product}
     intx PerBytecodeTrapLimit                      = 4               {product}
     intx PerMethodRecompilationCutoff              = 400             {product}
     intx PerMethodTrapLimit                        = 100             {product}
     bool PerfAllowAtExitRegistration               = false           {product}
     bool PerfBypassFileSystemCheck                 = false           {product}
     intx PerfDataMemorySize                        = 32768           {product}
     intx PerfDataSamplingInterval                  = 50              {product}
    ccstr PerfDataSaveFile                          =                 {product}
     bool PerfDataSaveToFile                        = false           {product}
     bool PerfDisableSharedMem                      = false           {product}
     intx PerfMaxStringConstLength                  = 1024            {product}
    uintx PermGenPadding                            = 3               {product}
    uintx PermMarkSweepDeadRatio                    = 20              {product}
    uintx PermSize                                  = 21810376        {pd product}
     intx PreInflateSpin                            = 10              {pd product}
     bool PreferInterpreterNativeStubs              = false           {pd product}
     intx PrefetchCopyIntervalInBytes               = -1              {product}
     intx PrefetchFieldsAhead                       = -1              {product}
     intx PrefetchScanIntervalInBytes               = -1              {product}
     bool PreserveAllAnnotations                    = false           {product}
    uintx PretenureSizeThreshold                    = 0               {product}
     bool PrintAdaptiveSizePolicy                   = false           {product}
     bool PrintCMSInitiationStatistics              = false           {product}
     intx PrintCMSStatistics                        = 0               {product}
     bool PrintClassHistogram                       = false           {manageable}
     bool PrintClassHistogramAfterFullGC            = false           {manageable}
     bool PrintClassHistogramBeforeFullGC           = false           {manageable}
     bool PrintCommandLineFlags                     = false           {product}
     bool PrintCompilation                          = false           {product}
     bool PrintConcurrentLocks                      = false           {manageable}
     intx PrintFLSCensus                            = 0               {product}
     intx PrintFLSStatistics                        = 0               {product}
     bool PrintFlagsFinal                           = false           {product}
     bool PrintFlagsInitial                         = false           {product}
     bool PrintGC                                   = false           {manageable}
     bool PrintGCApplicationConcurrentTime          = false           {product}
     bool PrintGCApplicationStoppedTime             = false           {product}
     bool PrintGCCause                              = true            {product}
     bool PrintGCDateStamps                         = false           {manageable}
     bool PrintGCDetails                            = false           {manageable}
     bool PrintGCTaskTimeStamps                     = false           {product}
     bool PrintGCTimeStamps                         = false           {manageable}
     bool PrintHeapAtGC                             = false           {product rw}
     bool PrintHeapAtGCExtended                     = false           {product rw}
     bool PrintHeapAtSIGBREAK                       = true            {product}
     bool PrintJNIGCStalls                          = false           {product}
     bool PrintJNIResolving                         = false           {product}
     bool PrintOldPLAB                              = false           {product}
     bool PrintOopAddress                           = false           {product}
     bool PrintPLAB                                 = false           {product}
     bool PrintParallelOldGCPhaseTimes              = false           {product}
     bool PrintPromotionFailure                     = false           {product}
     bool PrintReferenceGC                          = false           {product}
     bool PrintRevisitStats                         = false           {product}
     bool PrintSafepointStatistics                  = false           {product}
     intx PrintSafepointStatisticsCount             = 300             {product}
     intx PrintSafepointStatisticsTimeout           = -1              {product}
     bool PrintSharedSpaces                         = false           {product}
     bool PrintStringTableStatistics                = false           {product}
     bool PrintTLAB                                 = false           {product}
     bool PrintTenuringDistribution                 = false           {product}
     bool PrintTieredEvents                         = false           {product}
     bool PrintVMOptions                            = false           {product}
     bool PrintVMQWaitTime                          = false           {product}
     bool PrintWarnings                             = true            {product}
    uintx ProcessDistributionStride                 = 4               {product}
     bool ProfileInterpreter                        = true            {pd product}
     bool ProfileIntervals                          = false           {product}
     intx ProfileIntervalsTicks                     = 100             {product}
     intx ProfileMaturityPercentage                 = 20              {product}
     bool ProfileVM                                 = false           {product}
     bool ProfilerPrintByteCodeStatistics           = false           {product}
     bool ProfilerRecordPC                          = false           {product}
    uintx PromotedPadding                           = 3               {product}
     intx QueuedAllocationWarningCount              = 0               {product}
     bool RangeCheckElimination                     = true            {product}
     intx ReadPrefetchInstr                         = 0               {ARCH product}
     bool ReassociateInvariants                     = true            {C2 product}
     bool ReduceBulkZeroing                         = true            {C2 product}
     bool ReduceFieldZeroing                        = true            {C2 product}
     bool ReduceInitialCardMarks                    = true            {C2 product}
     bool ReduceSignalUsage                         = false           {product}
     intx RefDiscoveryPolicy                        = 0               {product}
     bool ReflectionWrapResolutionErrors            = true            {product}
     bool RegisterFinalizersAtInit                  = true            {product}
     bool RelaxAccessControlCheck                   = false           {product}
     bool RequireSharedSpaces                       = false           {product}
    uintx ReservedCodeCacheSize                     = 50331648        {pd product}
     bool ResizeOldPLAB                             = true            {product}
     bool ResizePLAB                                = true            {product}
     bool ResizeTLAB                                = true            {pd product}
     bool RestoreMXCSROnJNICalls                    = false           {product}
     bool RewriteBytecodes                          = true            {pd product}
     bool RewriteFrequentPairs                      = true            {pd product}
     intx SafepointPollOffset                       = 256             {C1 pd product}
     intx SafepointSpinBeforeYield                  = 2000            {product}
     bool SafepointTimeout                          = false           {product}
     intx SafepointTimeoutDelay                     = 10000           {product}
     bool ScavengeBeforeFullGC                      = true            {product}
     intx SelfDestructTimer                         = 0               {product}
    uintx SharedDummyBlockSize                      = 536870912       {product}
    uintx SharedMiscCodeSize                        = 4194304         {product}
    uintx SharedMiscDataSize                        = 5242880         {product}
    uintx SharedReadOnlySize                        = 10485760        {product}
    uintx SharedReadWriteSize                       = 13631488        {product}
     bool ShowMessageBoxOnError                     = false           {product}
     intx SoftRefLRUPolicyMSPerMB                   = 1000            {product}
     bool SplitIfBlocks                             = true            {C2 product}
     intx StackRedPages                             = 1               {pd product}
     intx StackShadowPages                          = 20              {pd product}
     bool StackTraceInThrowable                     = true            {product}
     intx StackYellowPages                          = 2               {pd product}
     bool StartAttachListener                       = false           {product}
     intx StarvationMonitorInterval                 = 200             {product}
     bool StressLdcRewrite                          = false           {product}
    uintx StringTableSize                           = 60013           {product}
     bool SuppressFatalErrorMessage                 = false           {product}
    uintx SurvivorPadding                           = 3               {product}
     intx SurvivorRatio                             = 8               {product}
     intx SuspendRetryCount                         = 50              {product}
     intx SuspendRetryDelay                         = 5               {product}
     intx SyncFlags                                 = 0               {product}
    ccstr SyncKnobs                                 =                 {product}
     intx SyncVerbose                               = 0               {product}
    uintx TLABAllocationWeight                      = 35              {product}
    uintx TLABRefillWasteFraction                   = 64              {product}
    uintx TLABSize                                  = 0               {product}
     bool TLABStats                                 = true            {product}
    uintx TLABWasteIncrement                        = 4               {product}
    uintx TLABWasteTargetPercent                    = 1               {product}
     intx TargetPLABWastePct                        = 10              {product}
     intx TargetSurvivorRatio                       = 50              {product}
    uintx TenuredGenerationSizeIncrement            = 20              {product}
    uintx TenuredGenerationSizeSupplement           = 80              {product}
    uintx TenuredGenerationSizeSupplementDecay      = 2               {product}
     intx ThreadPriorityPolicy                      = 0               {product}
     bool ThreadPriorityVerbose                     = false           {product}
    uintx ThreadSafetyMargin                        = 52428800        {product}
     intx ThreadStackSize                           = 1024            {pd product}
    uintx ThresholdTolerance                        = 10              {product}
     intx Tier0BackedgeNotifyFreqLog                = 10              {product}
     intx Tier0InvokeNotifyFreqLog                  = 7               {product}
     intx Tier0ProfilingStartPercentage             = 200             {product}
     intx Tier23InlineeNotifyFreqLog                = 20              {product}
     intx Tier2BackEdgeThreshold                    = 0               {product}
     intx Tier2BackedgeNotifyFreqLog                = 14              {product}
     intx Tier2CompileThreshold                     = 0               {product}
     intx Tier2InvokeNotifyFreqLog                  = 11              {product}
     intx Tier3BackEdgeThreshold                    = 60000           {product}
     intx Tier3BackedgeNotifyFreqLog                = 13              {product}
     intx Tier3CompileThreshold                     = 2000            {product}
     intx Tier3DelayOff                             = 2               {product}
     intx Tier3DelayOn                              = 5               {product}
     intx Tier3InvocationThreshold                  = 200             {product}
     intx Tier3InvokeNotifyFreqLog                  = 10              {product}
     intx Tier3LoadFeedback                         = 5               {product}
     intx Tier3MinInvocationThreshold               = 100             {product}
     intx Tier4BackEdgeThreshold                    = 40000           {product}
     intx Tier4CompileThreshold                     = 15000           {product}
     intx Tier4InvocationThreshold                  = 5000            {product}
     intx Tier4LoadFeedback                         = 3               {product}
     intx Tier4MinInvocationThreshold               = 600             {product}
     bool TieredCompilation                         = false           {pd product}
     intx TieredCompileTaskTimeout                  = 50              {product}
     intx TieredRateUpdateMaxTime                   = 25              {product}
     intx TieredRateUpdateMinTime                   = 1               {product}
     intx TieredStopAtLevel                         = 4               {product}
     bool TimeLinearScan                            = false           {C1 product}
     bool TraceBiasedLocking                        = false           {product}
     bool TraceClassLoading                         = false           {product rw}
     bool TraceClassLoadingPreorder                 = false           {product}
     bool TraceClassResolution                      = false           {product}
     bool TraceClassUnloading                       = false           {product rw}
     bool TraceDynamicGCThreads                     = false           {product}
     bool TraceGen0Time                             = false           {product}
     bool TraceGen1Time                             = false           {product}
    ccstr TraceJVMTI                                =                 {product}
     bool TraceLoaderConstraints                    = false           {product rw}
     bool TraceMonitorInflation                     = false           {product}
     bool TraceParallelOldGCTasks                   = false           {product}
     intx TraceRedefineClasses                      = 0               {product}
     bool TraceSafepointCleanupTime                 = false           {product}
     bool TraceSuspendWaitFailures                  = false           {product}
     intx TrackedInitializationLimit                = 50              {C2 product}
     bool TransmitErrorReport                       = false           {product}
     intx TypeProfileMajorReceiverPercent           = 90              {C2 product}
     intx TypeProfileWidth                          = 2               {product}
     intx UnguardOnExecutionViolation               = 0               {product}
     bool UnlinkSymbolsALot                         = false           {product}
     bool Use486InstrsOnly                          = false           {ARCH product}
     bool UseAES                                    = false           {product}
     bool UseAESIntrinsics                          = false           {product}
     intx UseAVX                                    = 99              {ARCH product}
     bool UseAdaptiveGCBoundary                     = false           {product}
     bool UseAdaptiveGenerationSizePolicyAtMajorCollection  = true            {product}
     bool UseAdaptiveGenerationSizePolicyAtMinorCollection  = true            {product}
     bool UseAdaptiveNUMAChunkSizing                = true            {product}
     bool UseAdaptiveSizeDecayMajorGCCost           = true            {product}
     bool UseAdaptiveSizePolicy                     = true            {product}
     bool UseAdaptiveSizePolicyFootprintGoal        = true            {product}
     bool UseAdaptiveSizePolicyWithSystemGC         = false           {product}
     bool UseAddressNop                             = false           {ARCH product}
     bool UseAltSigs                                = false           {product}
     bool UseAutoGCSelectPolicy                     = false           {product}
     bool UseBiasedLocking                          = true            {product}
     bool UseBimorphicInlining                      = true            {C2 product}
     bool UseBoundThreads                           = true            {product}
     bool UseCMSBestFit                             = true            {product}
     bool UseCMSCollectionPassing                   = true            {product}
     bool UseCMSCompactAtFullCollection             = true            {product}
     bool UseCMSInitiatingOccupancyOnly             = false           {product}
     bool UseCodeCacheFlushing                      = true            {product}
     bool UseCompiler                               = true            {product}
     bool UseCompilerSafepoints                     = true            {product}
     bool UseCompressedOops                         = false           {lp64_product}
     bool UseConcMarkSweepGC                        = false           {product}
     bool UseCondCardMark                           = false           {C2 product}
     bool UseCountLeadingZerosInstruction           = false           {ARCH product}
     bool UseCounterDecay                           = true            {product}
     bool UseDivMod                                 = true            {C2 product}
     bool UseDynamicNumberOfGCThreads               = false           {product}
     bool UseFPUForSpilling                         = false           {C2 product}
     bool UseFastAccessorMethods                    = true            {product}
     bool UseFastEmptyMethods                       = true            {product}
     bool UseFastJNIAccessors                       = true            {product}
     bool UseFastStosb                              = false           {ARCH product}
     bool UseG1GC                                   = false           {product}
     bool UseGCLogFileRotation                      = false           {product}
     bool UseGCOverheadLimit                        = true            {product}
     bool UseGCTaskAffinity                         = false           {product}
     bool UseHeavyMonitors                          = false           {product}
     bool UseHugeTLBFS                              = false           {product}
     bool UseInlineCaches                           = true            {product}
     bool UseInterpreter                            = true            {product}
     bool UseJumpTables                             = true            {C2 product}
     bool UseLWPSynchronization                     = true            {product}
     bool UseLargePages                             = false           {pd product}
     bool UseLargePagesIndividualAllocation         = false           {pd product}
     bool UseLinuxPosixThreadCPUClocks              = true            {product}
     bool UseLockedTracing                          = false           {product}
     bool UseLoopCounter                            = true            {product}
     bool UseLoopPredicate                          = true            {C2 product}
     bool UseMaximumCompactionOnSystemGC            = true            {product}
     bool UseMembar                                 = false           {pd product}
     bool UseNUMA                                   = false           {product}
     bool UseNUMAInterleaving                       = false           {product}
     bool UseNewLongLShift                          = false           {ARCH product}
     bool UseOSErrorReporting                       = false           {pd product}
     bool UseOldInlining                            = true            {C2 product}
     bool UseOnStackReplacement                     = true            {pd product}
     bool UseOnlyInlinedBimorphic                   = true            {C2 product}
     bool UseOprofile                               = false           {product}
     bool UseOptoBiasInlining                       = true            {C2 product}
     bool UsePPCLWSYNC                              = true            {product}
     bool UsePSAdaptiveSurvivorSizePolicy           = true            {product}
     bool UseParNewGC                               = false           {product}
     bool UseParallelGC                             = false           {product}
     bool UseParallelOldGC                          = false           {product}
     bool UsePerfData                               = true            {product}
     bool UsePopCountInstruction                    = false           {product}
     bool UseRDPCForConstantTableBase               = false           {C2 product}
     bool UseSHM                                    = false           {product}
     intx UseSSE                                    = 99              {product}
     bool UseSSE42Intrinsics                        = false           {product}
     bool UseSerialGC                               = false           {product}
     bool UseSharedSpaces                           = true            {product}
     bool UseSignalChaining                         = true            {product}
     bool UseSplitVerifier                          = true            {product}
     bool UseStoreImmI16                            = true            {ARCH product}
     bool UseStringCache                            = false           {product}
     bool UseSuperWord                              = true            {C2 product}
     bool UseTLAB                                   = true            {pd product}
     bool UseThreadPriorities                       = true            {pd product}
     bool UseTransparentHugePages                   = false           {product}
     bool UseTypeProfile                            = true            {product}
     bool UseUnalignedLoadStores                    = false           {ARCH product}
     bool UseVMInterruptibleIO                      = false           {product}
     bool UseVectoredExceptions                     = false           {pd product}
     bool UseXMMForArrayCopy                        = false           {product}
     bool UseXmmI2D                                 = false           {ARCH product}
     bool UseXmmI2F                                 = false           {ARCH product}
     bool UseXmmLoadAndClearUpper                   = true            {ARCH product}
     bool UseXmmRegToRegMoveAll                     = false           {ARCH product}
     bool VMThreadHintNoPreempt                     = false           {product}
     intx VMThreadPriority                          = -1              {product}
     intx VMThreadStackSize                         = 1024            {pd product}
     intx ValueMapInitialSize                       = 11              {C1 product}
     intx ValueMapMaxLoopSize                       = 8               {C1 product}
     intx ValueSearchLimit                          = 1000            {C2 product}
     bool VerifyMergedCPBytecodes                   = true            {product}
     intx WorkAroundNPTLTimedWaitHang               = 1               {product}
    uintx YoungGenerationSizeIncrement              = 20              {product}
    uintx YoungGenerationSizeSupplement             = 80              {product}
    uintx YoungGenerationSizeSupplementDecay        = 8               {product}
    uintx YoungPLABSize                             = 4096            {product}
     bool ZeroTLAB                                  = false           {product}
     intx hashCode                                  = 0               {product}
</pre>

That's a lot of shit!

# Format

If you read the docs then this will be a bit of review for you. If you haven't then I'll quickly cover the important bits.

* Boolean options are turned on with `-XX:+<OPTION_NAME>` and off with `-XX:-<OPTION_NAME>`. Note the `+` and `-`.
* String options are set with `-XX:<OPTION_NAME>=<STRING_VALUE>`.
* Numeric options just like strings, but have the special feature of allowing `m` or `M` for megabytes, `k` or `K` for kilobytes and `g` or `G` for gigabytes.

# Precedence

The JVM will use the *last* instance of a command line flag passed to it. This can be tested with the following:

Let's specify the maximum heap size twice. The last and higher priority is the `Xmx2G`.
<pre>
$ java -XX:+PrintFlagsFinal -Xmx1G -Xmx2G
…
uintx MaxHeapSize                              := 2147483648      {product}
…
</pre>

And again, reversed to verify:
<pre>
$ java -XX:+PrintFlagsFinal -Xmx2G -Xmx1G
uintx MaxHeapSize                              := 1073741824      {product}
</pre>

# Default Options

There are a few options that are good to turn on pretty much all the time. Let's talk about them shits!

## GC Logging

It's a good idea to enable GC logging for your program. This will vomit all manner of moonspeak in to a log file for analysis later when we learn more and can figure it out.

GC logging is effectively free and definitely worth what trivial amount of time it costs. I can't find any docs on this, but I know from past experience and conversations with JVM engineers that this is the case.

<pre>
-XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -XX:+PrintPromotionFailure -XX:PrintFLSStatistics=1 -Xloggc:$PUT_PATH_HERE -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=10M
</pre>

This gives the JVM instructions to log every smidge of GC info it has and put it in `$PUT_PATH_HERE`, rotate it 10 times at 10M for each rotation.

## JMX

Enabling JMX is also a great idea because you can hook up tools like JVisualVM or metric collection agents.

<pre>
-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=$PUT_PORT_HERE -Djava.rmi.server.hostname=$PUT_HOSTNAME_HERE
</pre>

<div class="panel panel-warning">
    <div class="panel-heading">
        <div class="panel-title"><i class="fa fa-rss"></i> No Authentication?</div>
    </div>
    <div class="panel-body">
        If this is a box available on the public internet be sure and swap that authenticate=false to true above!
    </div>
</div>

## HeapDump

<pre>
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$PUT_PATH_HERE
</pre>

Last we'll bring the HeapDump instructions up and have it drop the dump file into a directory so we can analyze any OOM failures.

# Closing

This leaves us with a final set of options that we should include in all our long-running JVM programs of:

<pre>
-XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationStoppedTime -XX:+PrintPromotionFailure -XX:PrintFLSStatistics=1 -Xloggc:$PUT_PATH_HERE -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=10M -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=$PUT_PORT_HERE -Djava.rmi.server.hostname=$PUT_HOSTNAME_HERE -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$PUT_PATH_HERE
</pre>

You can leave these off but in my experience this just means you'll need to roll all your instances to get these options turned on. Also, any JVM-based services you run such as [Cassandra](http://cassandra.apache.org) or [Zookeeper](http://zookeeper.apache.org) could benefit from these options. For some reason these options are not always enabled by default.
