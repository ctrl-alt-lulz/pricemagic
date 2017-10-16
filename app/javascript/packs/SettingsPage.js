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
      connected: false,
    };
  }
  render() {
    return (
            <Page title="Settings" >
              <Layout>
                <Layout.AnnotatedSection
                title="Google Analytics"
                description="Connect your Google Analytics Account"
                >
                <SettingToggle
                  action={{content: <a href="/google_auth" data-method="get" target="_blank">Goog Link</a>}}
                >
                This setting is <TextStyle variation="strong">disabled</TextStyle>.
                </SettingToggle>
                </Layout.AnnotatedSection>
                {this.renderAccount()}
              </Layout>
            </Page>
    );
  }
  connectAccountMarkup() {
              {console.log(this.props.google_api_id)}

    return (
      <Layout.AnnotatedSection
        title="Account"
        description="Connect your account to your Shopify store."
      >
        <AccountConnection
          action={{
            content: 'Connect',
            onAction: this.toggleConnection.bind(this, this.state),
          }}
          details="No account connected"
          termsOfService={<p>By clicking Connect, you are accepting Sample’s <Link url="https://polaris.shopify.com">Terms and Conditions</Link>, including a commission rate of 15% on sales.</p>}
        />
      </Layout.AnnotatedSection>
    );
  }
  disconnectAccountMarkup() {
    return (
      <Layout.AnnotatedSection
          title="Account"
          description="Disconnect your account from your Shopify store."
        >
        <AccountConnection
          connected
          action={{
            content: 'Disconnect',
            onAction: this.toggleConnection.bind(this, this.state),
          }}
          accountName="Google Analytics"
          title={<Link url="http://google.com">Google Analytics</Link>}
          details={"Account id: " + this.state.google_api_id}
        />
      </Layout.AnnotatedSection>
    );
  }
  toggleConnection() {
    this.setState(({connected}) => ({connected: !connected}));
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
