# Combine
It include the notes on combine framework and having example of combine usecase

Combine


Components of Combine Framework

1. Publisher :- Emit the values over time   


- Types of build in publishers:-
1. Just :- Send the value for only once
2. Future :- will give the result after the work has been done asynchronously
3. PassThroghSubject :- To send manual values
4. Current Value Subject :- Everytime keep the current value and emit the new value
5. UrlSession.datataskPublisher :- For Networking call
6. NotificationCenter.publisher :- For to observe the notification
7. Timer.Publish :- Gives the value over time

Usecase:- 
Networking (URLSession)
Timers (repeating events)
UI Events (button taps, text changes)
To observe Notifications



2. Subscriber :- Is receive the values from the publisher

- Types of the Subscriber: 
- 1. .sink:- Mostly used to consume the values.
- 2. .assign:- Assign the values directly to the property

UserCase:- 
To call the api and bind the result on UI.
To update Property
To print logs



3. Operator:- To transform the values given by the publisher. Whatever the response is coming from the api transform those.

1. Transforming: .map, .flatMap
2. Filtering: .filter, .removeDuplicates, .debounce
3. Combining: .merge, .zip, .combineLatest
4. Error Handling: .catch, .replaceError
5. Timing: .delay, .throttle, .timeout


Usecase:- 
To decode the network data
To add the form validation


4. Subjects:- Both the publisher and subscriber - we can able to the values manually

1. PassThroughSubject - Emits only new values.
2. CurrentValueSubject - Keep last value reminds and emit the new value.


Usecase:- 
To stream the value from the text field


5. Scheduler:- To determine the value to update on which thread

Types:
1. DispatchQueue.main :-  To update UI
2. DispatchQueue.global() :- Background work
3. Runloop, OperationQueue :- Custom Scheduling

Usecase:- 
To update the UI on main thread
For to heavy process is on background thread

1. Cancellable:- To cancel the subscription, To avoid memory leaks on combine use Cancellable.

Usecase :-
To cancel the api call on view disappear
Long running task clean up




Why to use combine rather than closure and delegates:-
Combine is the data stream pipe line  cancellable = URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .decode(type: [Post].self, decoder: JSONDecoder())
    .replaceError(with: [])
    .receive(on: DispatchQueue.main)
    .sink { [weak self] posts in
        self?.posts = posts
    }


- Declarative code :- It shows step by step in the pipeline 
- Error handling:- operators like .catch, .replaceError
- Threading:- .receive(on: )
- Cancellation :- cancellable.cancel() clean up
