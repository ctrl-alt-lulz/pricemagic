import React from 'react'
import ReactDOM from 'react-dom'
import { Page, Layout, TextContainer, Heading, Link } from '@shopify/polaris';

export default class FAQpage extends React.Component {
    constructor(props) {
        super(props);
        this.state = {};
    }

    render() {
        return (
            <Page title="FAQ">
                <Layout>
                    <Layout.AnnotatedSection>
                      <TextContainer>
                        <Heading>How do I set up Google Analytics with Enhanced Ecommerce?</Heading>
                          <p>Please follow the instructions provided by Shopify at: </p>
                              <Link url="https://help.shopify.com/manual/reports-and-analytics/google-analytics/google-analytics-setup#turn-on-ecommerce-tracking" external>
                                  https://help.shopify.com/manual/reports-and-analytics/google-analytics/
                                  google-analytics-setup#turn-on-ecommerce-tracking
                              </Link>
                      </TextContainer>
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection>
                      <TextContainer>
                        <Heading>How do I view the results of each test?</Heading>
                        <p>Click on the product title on the dashboard page to view the detailed product performance.</p>
                      </TextContainer>
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection>
                      <TextContainer>
                        <Heading>How many views should I set?</Heading>
                        <p>Our research shows that around 7400 views per price test is ideal for a statistically
                        significant result. However, the larger the difference between the prices the less views
                        you should need in general.</p>
                      </TextContainer>
                    </Layout.AnnotatedSection>
                </Layout>
            </Page>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const node = document.getElementById('faq-page')
    //const data = JSON.parse(node.getAttribute('data'))
    ReactDOM.render(<FAQpage />, node)
})

