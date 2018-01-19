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
                            <Heading>What parameters do I need to create a price test?</Heading>
                            <p> You must enter the number of views per price point to test and at minimum a percent increase value.</p>
                        </TextContainer>
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection>
                        <TextContainer>
                            <Heading>Can you give me an example of how a price test works?</Heading>
                            <p> Let’s say you have a product selling for $20. Set the upper and lower boundary
                                to 10% each, set two price points, and set 10,000 views. PriceMagic will change your
                                product price to $18, and collect data until it reaches 10,000 product views,
                                it will then move the price to $22, and repeat this process. Once it has finished it
                                will revert to the original price point of $20. You can view the graphs on the product
                                page to determine what price was best for your product!</p>
                        </TextContainer>
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection>
                        <TextContainer>
                            <Heading>How do I create a bulk price test?</Heading>
                            <p>First, check the box next to each product you want a test created for on the dashboard page.
                                Second, enter the price test parameters. Third press "Start Price Test".</p>
                        </TextContainer>
                    </Layout.AnnotatedSection>
                    <Layout.AnnotatedSection>
                        <TextContainer>
                            <Heading>How do I preview the price test before running it?</Heading>
                            <p>Click on the product title on the dashboard page and enter the price test parameters on that page.</p>
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
                    <Layout.AnnotatedSection>
                        <TextContainer>
                            <Heading>How can I contact you with any other questions?</Heading>
                            <p> Feel free to email us at <a href="mailto:thelannistergroup@gmail.com?bcc=ageorge010@vt.edu">thelannistergroup@gmail.com</a>.</p>
                        </TextContainer>
                    </Layout.AnnotatedSection>
                </Layout>
            </Page>
        );
    }
}

document.addEventListener('DOMContentLoaded', () => {
    const node = document.getElementById('faq-page')
    ReactDOM.render(<FAQpage />, node)
})

