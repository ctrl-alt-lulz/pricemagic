import React from 'react'
import ReactDOM from 'react-dom'
import RecurringChargesLink from './RecurringChargesLink.js';
import { Page, Layout, TextContainer, Heading, AccountConnection } from '@shopify/polaris';

export default class BillingDeclinePage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};
    }

    render() {
        return (
            <Page title="Billing was Declined">
                <Layout>
                    <Layout.AnnotatedSection>
                        <TextContainer>
                            <Heading>You will need a subscription to access the app.</Heading>
                        </TextContainer>
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection
                        title="Subscription Status"
                        description="Begin your subscription with PriceMagic."
                    >
                        <AccountConnection
                            action={{content: <RecurringChargesLink color='white'/>}}
                            details="No account connected"
                            termsOfService={<p>By clicking Connect, you are accepting PriceMagic’s Terms and Conditions.</p>}
                        />
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection>
                        <TextContainer>
                            <Heading>You can uninstall this app by going to the Apps page in the left sidebar and
                                clicking the trashcan icon next to the Price Magic application.</Heading>
                        </TextContainer>
                    </Layout.AnnotatedSection>
                </Layout>
            </Page>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const node = document.getElementById('billing-decline-page')
    ReactDOM.render(<BillingDeclinePage />, node)
})

