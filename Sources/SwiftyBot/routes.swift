import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // MARK: - Telegram Bot
    
    /// Setting up the POST request with Telegram secret key.
    /// With a secret path to be sure that nobody else knows that URL.
    /// https://core.telegram.org/bots/api#setwebhook
//    router.get("telegram", telegramSecret) { request -> HTTPResponse in
//        /// Check for "hub.mode", "hub.verify_token" & "hub.challenge" query parameters.
//        guard try request.parameters.next(String.self) == "subscribe" && request.data["hub.verify_token"]?.string == messengerSecret, let challenge = request.data["hub.challenge"]?.string else {
//            throw Abort(.badRequest, reason: "Missing Messenger verification data.")
//        }
//
//        /// Create a response with the challenge query parameter to verify the webhook.
//        let body = try HTTPBody(data: JSONEncoder().encode(challenge))
//        return HTTPResponse(status: .ok, headers: ["Content-Type": "text/plain"], body: body)
//    }
//    router.post(telegramSecret, at: "telegram") { request, data in
//        /// Let's prepare the response message text.
//        var response: String = ""
//
//        /// Chat ID from request JSON.
//        let chatID: Int = request.data["message", "chat", "id"]?.int ?? 0
//        /// Message text from request JSON.
//        let message: String = request.data["message", "text"]?.string ?? ""
//        /// User first name from request JSON.
//        let userFirstName: String = request.data["message", "from", "first_name"]?.string ?? ""
//
//        /// Check if the message is empty.
//        if message.isEmpty {
//            /// Set the response message text.
//            response = "I'm sorry but your message is empty 😢"
//            /// The message is not empty.
//        } else {
//            /// Check if the message is a Telegram command.
//            if message.hasPrefix("/") {
//                /// Check what type of command is.
//                switch message {
//                /// Start command "/start".
//                case "/start":
//                    /// Set the response message text.
//                    response = "Welcome to SwiftyBot " + userFirstName + "!\n" +
//                    "To list all available commands type /help"
//                /// Help command "/help".
//                case "/help":
//                    /// Set the response message text.
//                    response = "Welcome to SwiftyBot " +
//                        "an example on how to create a Telegram bot with Swift using Vapor.\n" +
//                        "https://www.fabriziobrancati.com/SwiftyBot\n\n" +
//                        "/start - Welcome message\n" +
//                        "/help - Help message\n" +
//                    "Any text - Returns the reversed message"
//                /// Command not valid.
//                default:
//                    /// Set the response message text and suggest to type "/help".
//                    response = "Unrecognized command.\n" +
//                    "To list all available commands type /help"
//                }
//                /// It is not a Telegram command, so create a reversed message text.
//            } else {
//                /// Set the response message text.
//                response = message.reversed(preserveFormat: true)
//            }
//        }
//
//        /// Create the JSON response.
//        /// https://core.telegram.org/bots/api#sendmessage
//        return try JSON(node: [
//            "method": "sendMessage",
//            "chat_id": chatID,
//            "text": response
//            ]
//        )
//    }
//
//    // MARK: - Messenger Bot
//
//    /// Setting up the GET request with Messenger secret key.
//    /// With a secret path to be sure that nobody else knows that URL.
//    /// This is the Step 2 of Facebook Messenger Quick Start guide:
//    /// https://developers.facebook.com/docs/messenger-platform/guides/quick-start#setup_webhook
//    router.get("messenger", messengerSecret) { request, data in
//        /// Check for "hub.mode", "hub.verify_token" & "hub.challenge" query parameters.
//        guard request.data["hub.mode"]?.string == "subscribe" && request.data["hub.verify_token"]?.string == messengerSecret, let challenge = request.data["hub.challenge"]?.string else {
//            throw Abort(.badRequest, reason: "Missing Messenger verification data.")
//        }
//
//        /// Create a response with the challenge query parameter to verify the webhook.
//        return Response(status: .ok, headers: ["Content-Type": "text/plain"], body: challenge)
//    }
//
//    /// Setting up the POST request with Messenger secret key.
//    /// With a secret path to be sure that nobody else knows that URL.
//    /// This is the Step 5 of Facebook Messenger Quick Start guide:
//    /// https://developers.facebook.com/docs/messenger-platform/guides/quick-start#receive_messages
//    router.post(messengerSecret, at: "messenger") { request, data in
//        /// Check that the request comes from a "page".
//        guard request.json?["object"]?.string == "page" else {
//            /// Throw an abort response, with a custom message.
//            throw Abort(.badRequest, reason: "Message not generated by a page.")
//        }
//
//        /// Prepare the response message text.
//        var response: Node = ["text": "Unknown error."]
//        /// Entries from request JSON.
//        let entries: [JSON] = request.json?["entry"]?.array ?? []
//
//        /// Iterate over all entries.
//        for entry in entries {
//            /// Messages from entry.
//            let messaging: [JSON] = entry.object?["messaging"]?.array ?? []
//
//            /// Iterate over all messaging objects.
//            for event in messaging {
//                /// Message of the event.
//                let message: [String: JSON] = event.object?["message"]?.object ?? [:]
//                /// Postback of the event.
//                let postback: [String: JSON] = event.object?["postback"]?.object ?? [:]
//                /// Sender of the event.
//                let sender: [String: JSON] = event.object?["sender"]?.object ?? [:]
//                /// Sender ID, it is used to make a response to the right user.
//                let senderID: String = sender["id"]?.string ?? ""
//                /// Text sent to bot.
//                let text: String = message["text"]?.string ?? ""
//
//                /// Check if is a postback action.
//                if !postback.isEmpty {
//                    /// Get payload from postback.
//                    let payload: String = postback["payload"]?.string ?? "No payload provided by developer."
//                    /// Set the response message text.
//                    response = Messenger.message(payload)
//                    /// Check if the message object is empty.
//                } else if message.isEmpty {
//                    /// Set the response message text.
//                    response = Messenger.message("Webhook received unknown event.")
//                    /// Check if the message text is empty
//                } else if text.isEmpty {
//                    /// Set the response message text.
//                    response = Messenger.message("I'm sorry but your message is empty 😢")
//                    /// The user greeted the bot.
//                } else if text.hasGreetings() {
//                    response = Messenger.message("Hi!\nThis is an example on how to create a bot with Swift.\nIf you want to see more try to send me \"buy\", \"sell\" or \"shop\".")
//                    /// The user wants to buy something.
//                } else if text.lowercased().range(of: "sell") || text.lowercased().range(of: "buy") || text.lowercased().range(of: "shop") {
//                    do {
//                        /// Create all the elements in elements object of the Messenger structured message.
//                        /// First Element: BFKit-Swift
//                        let BFKitSwift = try Messenger.Element(title: "BFKit-Swift", subtitle: "BFKit-Swift is a collection of useful classes, structs and extensions to develop Apps faster.", itemURL: "https://github.com/FabrizioBrancati/BFKit-Swift", imageURL: "https://github.fabriziobrancati.com/bfkit/resources/banner-swift.png", buttons: [
//                            Messenger.Element.Button(type: .webURL, title: "Open in GitHub", url: "https://github.com/FabrizioBrancati/BFKit-Swift"),
//                            Messenger.Element.Button(type: .postback, title: "Call Postback", payload: "BFKit-Swift payload.")])
//                        /// Second Element: BFKit
//                        let BFKit = try Messenger.Element(title: "BFKit", subtitle: "BFKit is a collection of useful classes and categories to develop Apps faster.", itemURL: "https://github.com/FabrizioBrancati/BFKit", imageURL: "https://github.fabriziobrancati.com/bfkit/resources/banner-objc.png", buttons: [
//                            Messenger.Element.Button(type: .webURL, title: "Open in GitHub", url: "https://github.com/FabrizioBrancati/BFKit"),
//                            Messenger.Element.Button(type: .postback, title: "Call Postback", payload: "BFKit payload.")])
//                        /// Third Element: SwiftyBot
//                        let SwiftyBot = try Messenger.Element(title: "SwiftyBot", subtitle: "How to create a Telegram & Messenger bot with Swift using Vapor on Ubuntu / macOS", itemURL: "https://github.com/FabrizioBrancati/SwiftyBot", imageURL: "https://github.fabriziobrancati.com/swiftybot/resources/swiftybot-banner-new.png", buttons: [
//                            Messenger.Element.Button(type: .webURL, title: "Open in GitHub", url: "https://github.com/FabrizioBrancati/SwiftyBot"),
//                            Messenger.Element.Button(type: .postback, title: "Call Postback", payload: "SwiftyBot payload.")])
//
//                        /// Create the elements array.
//                        var elements: [Messenger.Element] = []
//                        /// Add BFKit-Swift to elements array.
//                        elements.append(BFKitSwift)
//                        /// Add BFKit to elements array.
//                        elements.append(BFKit)
//                        /// Add SwiftyBot to elements array.
//                        elements.append(SwiftyBot)
//
//                        /// Create a structured message to sell something to the user.
//                        response = try Messenger.structuredMessage(elements: elements)
//                    } catch {
//                        /// Throw an abort response, with a custom message.
//                        throw Abort(.badRequest, reason: "Error while creating elements.")
//                    }
//                    /// The message object and its text are not empty, and the user does not want to buy anything, so create a reversed message text.
//                } else {
//                    /// Set the response message text.
//                    response = Messenger.message(text.reversed(preserveFormat: true))
//                }
//
//                /// Creating the response JSON data bytes.
//                /// At Step 6 of Facebook Messenger Quick Start guide, using Node.js demo, they told you to send back the "recipient.id", but the correct one is "sender.id".
//                /// https://developers.facebook.com/docs/messenger-platform/guides/quick-start#send_text_message
//                var responseData: JSON = JSON()
//                try responseData.set("messaging_type", "RESPONSE")
//                try responseData.set("recipient", ["id": senderID])
//                try responseData.set("message", response)
//
//                /// Calling the Facebook API to send the response.
//                let _: Response = try droplet.client.post("https://graph.facebook.com/v3.0/me/messages", query: ["access_token": messengerToken], ["Content-Type": "application/json"], Body.data(responseData.makeBytes()))
//            }
//        }
//
//        /// Sending an HTTP 200 OK response is required.
//        /// https://developers.facebook.com/docs/messenger-platform/webhook-reference#response
//        /// The header is added just to mute a Vapor warning.
//        return Response(status: .ok, headers: ["Content-Type": "application/json"])
//    }
}
