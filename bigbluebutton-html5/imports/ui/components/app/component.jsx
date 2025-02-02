import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { throttle } from 'lodash';
import { defineMessages, injectIntl, intlShape } from 'react-intl';
import Modal from 'react-modal';
import browser from 'browser-detect';
import PanelManager from '/imports/ui/components/panel-manager/component';
import PollingContainer from '/imports/ui/components/polling/container';
import logger from '/imports/startup/client/logger';
import ActivityCheckContainer from '/imports/ui/components/activity-check/container';
import UserInfoContainer from '/imports/ui/components/user-info/container';
import ToastContainer from '../toast/container';
import ModalContainer from '../modal/container';
import NotificationsBarContainer from '../notifications-bar/container';
import AudioContainer from '../audio/container';
import ChatAlertContainer from '../chat/alert/container';
import BannerBarContainer from '/imports/ui/components/banner-bar/container';
import WaitingNotifierContainer from '/imports/ui/components/waiting-users/alert/container';
import { startBandwidthMonitoring, updateNavigatorConnection } from '/imports/ui/services/network-information/index';
import LockNotifier from '/imports/ui/components/lock-viewers/notify/container';

import { styles } from './styles';

const MOBILE_MEDIA = 'only screen and (max-width: 40em)';
const APP_CONFIG = Meteor.settings.public.app;
const DESKTOP_FONT_SIZE = APP_CONFIG.desktopFontSize;
const MOBILE_FONT_SIZE = APP_CONFIG.mobileFontSize;
const ENABLE_NETWORK_INFORMATION = APP_CONFIG.enableNetworkInformation;

const intlMessages = defineMessages({
  userListLabel: {
    id: 'app.userList.label',
    description: 'Aria-label for Userlist Nav',
  },
  chatLabel: {
    id: 'app.chat.label',
    description: 'Aria-label for Chat Section',
  },
  mediaLabel: {
    id: 'app.media.label',
    description: 'Aria-label for Media Section',
  },
  actionsBarLabel: {
    id: 'app.actionsBar.label',
    description: 'Aria-label for ActionsBar Section',
  },
  iOSWarning: {
    id: 'app.iOSWarning.label',
    description: 'message indicating to upgrade ios version',
  },
  pollPublishedLabel: {
    id: 'app.whiteboard.annotations.poll',
    description: 'message displayed when a poll is published',
  },
});

const propTypes = {
  navbar: PropTypes.element,
  sidebar: PropTypes.element,
  media: PropTypes.element,
  actionsbar: PropTypes.element,
  captions: PropTypes.element,
  userListIsOpen: PropTypes.bool.isRequired,
  chatIsOpen: PropTypes.bool.isRequired,
  locale: PropTypes.string,
  intl: intlShape.isRequired,
};

const defaultProps = {
  navbar: null,
  sidebar: null,
  media: null,
  actionsbar: null,
  captions: null,
  locale: 'en',
};

class App extends Component {
  constructor() {
    super();

    this.state = {
      enableResize: !window.matchMedia(MOBILE_MEDIA).matches,
    };

    this.handleWindowResize = throttle(this.handleWindowResize).bind(this);
  }

  componentDidMount() {
    const {
      locale, notify, intl, validIOSVersion,
    } = this.props;
    const BROWSER_RESULTS = browser();
    const isMobileBrowser = BROWSER_RESULTS.mobile || BROWSER_RESULTS.os.includes('Android');

    Modal.setAppElement('#app');
    document.getElementsByTagName('html')[0].lang = locale;
    document.getElementsByTagName('html')[0].style.fontSize = isMobileBrowser ? MOBILE_FONT_SIZE : DESKTOP_FONT_SIZE;

    const body = document.getElementsByTagName('body')[0];
    if (BROWSER_RESULTS && BROWSER_RESULTS.name) {
      body.classList.add(`browser-${BROWSER_RESULTS.name}`);
    }
    if (BROWSER_RESULTS && BROWSER_RESULTS.os) {
      body.classList.add(`os-${BROWSER_RESULTS.os.split(' ').shift().toLowerCase()}`);
    }

    if (!validIOSVersion()) {
      notify(
        intl.formatMessage(intlMessages.iOSWarning),
        'error',
        'warning',
      );
    }

    this.handleWindowResize();
    window.addEventListener('resize', this.handleWindowResize, false);

    if (ENABLE_NETWORK_INFORMATION) {
      if (navigator.connection) {
        this.handleNetworkConnection();
        navigator.connection.addEventListener('change', this.handleNetworkConnection);
      }

      startBandwidthMonitoring();
    }


    logger.info({ logCode: 'app_component_componentdidmount' }, 'Client loaded successfully');
  }

  componentDidUpdate(prevProps, prevState) {
    const { hasPublishedPoll, intl, notify } = this.props;
    if (!prevProps.hasPublishedPoll && hasPublishedPoll) {
      notify(
        intl.formatMessage(intlMessages.pollPublishedLabel),
        'info',
        'polling',
      );
    }
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleWindowResize, false);
    if (navigator.connection) {
      navigator.connection.addEventListener('change', this.handleNetworkConnection, false);
    }
  }

  handleWindowResize() {
    const { enableResize } = this.state;
    const shouldEnableResize = !window.matchMedia(MOBILE_MEDIA).matches;
    if (enableResize === shouldEnableResize) return;

    this.setState({ enableResize: shouldEnableResize });
  }

  handleNetworkConnection() {
    updateNavigatorConnection(navigator.connection);
  }

  renderPanel() {
    const { enableResize } = this.state;
    const { openPanel } = this.props;

    return (
      <PanelManager
        {...{
          openPanel,
          enableResize,
        }}
      />
    );
  }

  renderNavBar() {
    const { navbar } = this.props;

    if (!navbar) return null;

    return (
      <header className={styles.navbar}>
        {navbar}
      </header>
    );
  }

  renderSidebar() {
    const { sidebar } = this.props;

    if (!sidebar) return null;

    return (
      <aside className={styles.sidebar}>
        {sidebar}
      </aside>
    );
  }

  renderCaptions() {
    const { captions } = this.props;

    if (!captions) return null;

    return (
      <div className={styles.captionsWrapper}>
        {captions}
      </div>
    );
  }

  renderMedia() {
    const {
      media, intl, chatIsOpen, userListIsOpen,
    } = this.props;

    if (!media) return null;

    return (
      <section
        className={styles.media}
        aria-label={intl.formatMessage(intlMessages.mediaLabel)}
        aria-hidden={userListIsOpen || chatIsOpen}
      >
        {media}
        {this.renderCaptions()}
      </section>
    );
  }

  renderActionsBar() {
    const {
      actionsbar, intl, userListIsOpen, chatIsOpen,
    } = this.props;

    if (!actionsbar) return null;

    return (
      <section
        className={styles.actionsbar}
        aria-label={intl.formatMessage(intlMessages.actionsBarLabel)}
        aria-hidden={userListIsOpen || chatIsOpen}
      >
        {actionsbar}
      </section>
    );
  }

  renderActivityCheck() {
    const { User } = this.props;

    const { inactivityCheck, responseDelay } = User;

    return (inactivityCheck ? (
      <ActivityCheckContainer
        inactivityCheck={inactivityCheck}
        responseDelay={responseDelay}
      />) : null);
  }

  renderUserInformation() {
    const { UserInfo, User } = this.props;

    return (UserInfo.length > 0 ? (
      <UserInfoContainer
        UserInfo={UserInfo}
        requesterUserId={User.userId}
        meetingId={User.meetingId}
      />) : null);
  }

  render() {
    const {
      customStyle, customStyleUrl, openPanel,
    } = this.props;

    return (
      <main className={styles.main}>
        {this.renderActivityCheck()}
        {this.renderUserInformation()}
        <BannerBarContainer />
        <NotificationsBarContainer />
        <section className={styles.wrapper}>
          <div className={openPanel ? styles.content : styles.noPanelContent}>
            {this.renderNavBar()}
            {this.renderMedia()}
            {this.renderActionsBar()}
          </div>
          {this.renderPanel()}
          {this.renderSidebar()}
        </section>
        <PollingContainer />
        <ModalContainer />
        <AudioContainer />
        <ToastContainer rtl />
        <ChatAlertContainer />
        <WaitingNotifierContainer />
        <LockNotifier />
        {customStyleUrl ? <link rel="stylesheet" type="text/css" href={customStyleUrl} /> : null}
        {customStyle ? <link rel="stylesheet" type="text/css" href={`data:text/css;charset=UTF-8,${encodeURIComponent(customStyle)}`} /> : null}
      </main>
    );
  }
}

App.propTypes = propTypes;
App.defaultProps = defaultProps;

export default injectIntl(App);
