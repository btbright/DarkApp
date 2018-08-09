# DarkApp

An experimental group chat interface that displays text while it's being written to all members of the group. Intended to generate an experience closer to in-person discussion than a traditional group chat thread. E.g. ephermeral and overlapping

## notes

The original idea was for this to be used in-person and messages would be transferred over the iOS MultipeerConnectivity API. But, in experimenting, I found that the connection wasn't consistent enough to deliver push-notifications to locked devices. It could also work over the network but it was mostly a for-fun project and playing with the bluetooth API was fun.
