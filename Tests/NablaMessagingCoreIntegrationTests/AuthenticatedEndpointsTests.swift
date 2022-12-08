import Combine
import NablaCore
import NablaMessagingCore
import XCTest

class AuthenticatedEndpointsTests: XCTestCase {
    private var nablaClient: NablaClient!
    private var messagingClient: NablaMessagingClient!
    
    override func setUp() {
        super.setUp()
        nablaClient = NablaClient(modules: [], configuration: .init(apiKey: ""), name: "")
        messagingClient = NablaMessagingClient(container: nablaClient.container)
    }
    
    private func assertAuthenticationErrorPublisher<T, E: Error>(_ publisher: AnyPublisher<T, E>) {
        let receiveErrorCalled = expectation(description: "receiveCompletion called with error")
        let receiveCompletionCalled = expectation(description: "receiveCompletion called with finished")
        receiveCompletionCalled.isInverted = true
        let receiveValueCalled = expectation(description: "receiveValue called")
        receiveValueCalled.isInverted = true
        let cancellable = publisher.sink { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                XCTAssert(error is MissingAuthenticationProviderError)
                receiveErrorCalled.fulfill()
            }
        } receiveValue: { _ in
            receiveValueCalled.fulfill()
        }
        waitForExpectations(timeout: 0.5)
        XCTAssertNotNil(cancellable)
    }
    
    func testWatchConversationsFailsWhenNotAuthenticated() {
        let publisher = messagingClient.watchConversations()
        assertAuthenticationErrorPublisher(publisher)
    }
    
    func testCreateConversationFailsWhenNotAuthenticated() async {
        do {
            _ = try await messagingClient.createConversation(
                withMessage: .text(content: "Hello"),
                title: nil,
                providerIds: nil
            )
            XCTFail("Call should not succeed")
        } catch {
            XCTAssert(error is MissingAuthenticationProviderError)
        }
    }
    
    func testWatchConversationFailsWhenNotAuthenticated() {
        let publisher = messagingClient.watchConversation(withId: .init())
        assertAuthenticationErrorPublisher(publisher)
    }
    
    func testWatchItemsOfConversationWithIdFailsWhenNotAuthenticated() {
        let publisher = messagingClient.watchItems(ofConversationWithId: .init())
        assertAuthenticationErrorPublisher(publisher)
    }
    
    func testMarkConversationAsSeenFailsWhenNotAuthenticated() async {
        do {
            _ = try await messagingClient.markConversationAsSeen(.init())
            XCTFail("Call should not succeed")
        } catch {
            XCTAssert(error is MissingAuthenticationProviderError)
        }
    }
    
    func testSetIsTypingFailsWhenNotAuthenticated() async {
        do {
            _ = try await messagingClient.setIsTyping(true, inConversationWithId: .init())
            XCTFail("Call should not succeed")
        } catch {
            XCTAssert(error is MissingAuthenticationProviderError)
        }
    }
    
    func testSendMessageInConversationWithIdFailsWhenNotAuthenticated() async {
        do {
            _ = try await messagingClient.sendMessage(
                .text(content: "Hello world!"),
                replyingToMessageWithId: nil,
                inConversationWithId: .init()
            )
            XCTFail("Call should not succeed")
        } catch {
            XCTAssert(error is MissingAuthenticationProviderError)
        }
    }
    
    func testRetrySendingItemWithIdInConversationWithIdFailsWhenNotAuthenticated() async {
        do {
            _ = try await messagingClient.retrySending(itemWithId: .init(), inConversationWithId: .init())
            XCTFail("Call should not succeed")
        } catch {
            XCTAssert(error is MissingAuthenticationProviderError)
        }
    }
    
    func testDeleteMessageWithIdInConversationWithIdFailsWhenNotAuthenticated() async {
        do {
            _ = try await messagingClient.deleteMessage(withId: .init(), conversationId: .init())
            XCTFail("Call should not succeed")
        } catch {
            XCTAssert(error is MissingAuthenticationProviderError)
        }
    }
}
