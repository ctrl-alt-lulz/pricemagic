import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import RecurringChargesLink from './RecurringChargesLink.js'
import NativeListener from 'react-native-listener';
import { Page, TextStyle, Layout,AccountConnection, SettingToggle, Link } from '@shopify/polaris';

// <% @recurring_charges.each do |charge| %>
//   <div>
//     <h2><%= charge.name %></h2>
//     <h3><%= charge.price %></h3>
//     <h4><%= charge.billing_on %></h4>
//     <%= link_to 'Cancel Charge', recurring_charge_path(charge), method: :delete %>
//   </div>
// <% end %>

export default class SettingsPage extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      recurring_charges: this.props.recurring_charges,
      google_api_id: this.props.google_api_id,
      connected: this.props.user_connected,
    };
  }
  render() {
    return (
            <Page title="Settings" >
              <Layout>
                {this.renderAccount()}
              </Layout>
            </Page>
    );
  }
  connectAccountMarkup() {
              {console.log(this.props.google_api_id)}
  const linkStyle = {
      color: 'white',
    };
    return (
      <Layout.AnnotatedSection
        title="Google Analytics"
        description="Connect to your Google Analytics account."
      >
        <AccountConnection
          action={{content: <a href="/google_auth" data-method="get" style={linkStyle} target="_blank">Connect</a>}}
          details="No account connected"
          termsOfService={<p>By clicking Connect, you are accepting Google’s <Link url="https://www.google.com/analytics/terms/us.html">Terms and Conditions</Link>.</p>}
        />
      </Layout.AnnotatedSection>
    );
  }
  
  disconnectAccountMarkup() {
    const linkStyle = {
      color: 'black',
    };
    return (
      <Layout.AnnotatedSection
          title="Account"
          description="Disconnect your Google Analytics from PriceMagic."
        >
        <AccountConnection
          connected
          action={{content: <a href="/google_auth" data-method="delete" style={linkStyle} target="_blank"
                   data-confirm="Disconnecting your Google Analytics Account will end all active price tests,
                                 are you sure you want to continue?">Disconnect</a>}}
          accountName="Google Analytics"
          title={<Link url="http://google.com">Google Analytics</Link>}
          details={"Account id: " + this.state.google_api_id}
        />
      </Layout.AnnotatedSection>
    );
  }
  renderAccount() {
    return this.state.connected
      ? this.disconnectAccountMarkup()
      : this.connectAccountMarkup();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('settings-page')
  const data= JSON.parse(node.getAttribute('data'));
ReactDOM.render(<SettingsPage {...data}/>, node)
})
