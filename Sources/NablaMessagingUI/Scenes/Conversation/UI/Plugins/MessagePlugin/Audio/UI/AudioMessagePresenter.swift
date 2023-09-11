import Foundation
import NablaCoreFork
import NablaMessagingCoreFork

final class AudioMessagePresenter:
    MessagePresenter<
        AudioMessageContentView,
        AudioMessageViewItem,
        ConversationMessageCell<AudioMessageContentView>
    > {
    // MARK: - Init
    
    init(
        logger: Logger,
        item: AudioMessageViewItem,
        conversationId: UUID,
        client: NablaMessagingClientProtocol,
        delegate: ConversationCellPresenterDelegate
    ) {
        self.logger = logger
        super.init(
            logger: logger,
            item: item,
            conversationId: conversationId,
            client: client,
            delegate: delegate,
            transformContent: transformer.transform
        )
        currentTimeSeconds = item.audio.durationMs / 1000
    }
    
    // MARK: - Private
    
    private let logger: Logger

    private lazy var audioPlayer: AudioPlayer = {
        let player = AudioPlayer(dependencies: .init(logger: logger))
        player.delegate = self
        return player
    }()

    private let transformer = AudioMessageContentViewModelTransformer()

    private lazy var currentTimeSeconds = 0 {
        didSet {
            reloadUI()
        }
    }

    private var isPlaying = false {
        didSet {
            reloadUI()
        }
    }

    private func reloadUI() {
        transformer.update(isPlaying: isPlaying, currentTimeSeconds: currentTimeSeconds)
        DispatchQueue.main.async {
            self.updateView()
        }
    }
}

extension AudioMessagePresenter: AudioMessageContentViewDelegate {
    // MARK: - AudioMessageContentViewDelegate

    func audioMessageContentViewDidTapPlayPauseButton(_: AudioMessageContentView) {
        if isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play(item.audio)
        }
    }
}

extension AudioMessagePresenter: AudioPlayerDelegate {
    // MARK: - AudioPlayerDelegate

    func audioPlayer(_: AudioPlayer, didUpdateCurrentPlayTime time: TimeInterval) {
        currentTimeSeconds = (item.audio.durationMs / 1000) - Int(time)
    }

    func audioPlayer(_: AudioPlayer, didUpdatePlayingState isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
}
